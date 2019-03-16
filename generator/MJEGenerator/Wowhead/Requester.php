<?php
declare(strict_types=1);

namespace MJEGenerator\Wowhead;

use Amp\Artax\DefaultClient;
use Amp\Artax\Response;
use function Amp\File\isfile;
use function Amp\File\open;
use function Amp\File\put;
use MJEGenerator\Mount;

class Requester
{

    private $client;

    public function __construct()
    {
        $this->client = new DefaultClient;
    }


    private function get(string $url, int $retry = 5)
    {
        $html = null;
        /** @var Response $response */
        $response = yield $this->client->request($url);
        if ($response->getStatus() === 200) {
            $html = yield $response->getBody();
        }

        if (false === empty($html)) {
            return $html;
        }
        if ($retry > 0) {
            return yield from $this->get($url, $retry - 1);
        }

        return '';
    }

    /**
     * @return int[][] spellId => itemIds
     */
    public function fetchMountItems()
    {
        $result  = [];
        $matches = [];
        $html    = yield from $this->get('http://www.wowhead.com/mount-spells/live-only:on');
        if (preg_match('/var listviewspells = (.*);/iU', $html, $matches)) {
            $json = $matches[1];
            $json = str_replace(['reagents', 'npcmodel'], ['"reagents"', '"npcmodel"'], $json);
            $data = json_decode($json, true);
            foreach ($data as $item) {
                $result[$item['id']] = array_column($item['reagents'] ?? [], 0);
            }

            $result = array_filter($result);
        }

        return $result;
    }

    /**
     * @param int $spellId
     *
     * @return Animation[]
     */
    public function fetchAnimationsBySpellId(int $spellId)
    {
        $html = yield from $this->get('https://www.wowhead.com/spell=' . $spellId);

        $pattern = '#onclick="ModelViewer.show\(.*displayId: (\d+),?.*}\)"\>View in 3D#is';
        $matches = [];
        if (preg_match_all($pattern, $html, $matches, PREG_SET_ORDER)) {
            $json = yield from $this->get('https://wow.zamimg.com/modelviewer/meta/npc/' . $matches[0][1] . '.json');
            $json = json_decode($json);

            if (empty($json->Model)) {
                throw new \Exception('no model id from wowhead for: ' . $spellId);
            }

            $fileName      = $json->Model . '.mo3';
            $localFileName = 'MO3' . DIRECTORY_SEPARATOR . $fileName;
            if (false === yield isfile($localFileName)) {
                $mo3File = yield from $this->get('https://wow.zamimg.com/modelviewer/mo3/' . $fileName);
                yield put($localFileName, $mo3File);
            }

            $stream    = yield open($localFileName, 'r');
            $mo3Reader = new MO3FileReader($stream);

            return yield from $mo3Reader->fetchAnimations();
        }

        return [];
    }

    public function fetchItemTooltip(int $itemId)
    {
        $body = yield from $this->get('https://www.wowhead.com/tooltip/item/' . $itemId . '&json&power');
        $json = json_decode($body, true);
        return $json['tooltip_enus'];
    }
}