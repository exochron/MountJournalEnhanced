<?php
declare(strict_types=1);

namespace MJEGenerator\Wowhead;

use GuzzleHttp\Client;
use GuzzleHttp\Pool;
use GuzzleHttp\Psr7\Request;
use Psr\Http\Message\ResponseInterface;
use RuntimeException;

class Requester
{
    public const CHANNEL_WWW = 'www';

    private $client;
    private $channel;

    public function __construct(string $channel, Client $client)
    {
        $this->client  = $client;
        $this->channel = $channel;
    }

    private function get(string $url): string
    {
        $html     = '';
        $response = $this->client->get($url);
        if ($response->getStatusCode() === 200) {
            $html = $response->getBody()->getContents();
        }

        if (false === empty($html)) {
            return $html;
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

        $url = 'mount-spells/live-only:';
        $url .= ($this->channel === self::CHANNEL_WWW ? 'on' : 'off');

        $html = $this->get($url);
        if (preg_match('/var listviewspells = (.*);/iU', $html, $matches)) {
            $json = $matches[1];
            $json = str_replace(
                ['reagents', 'npcmodel', 'popularity'],
                ['"reagents"', '"npcmodel"', '"popularity"'],
                $json
            );
            $data = json_decode($json, true, 512, JSON_THROW_ON_ERROR);
            foreach ($data as $item) {
                $result[$item['id']] = array_column($item['reagents'] ?? [], 0);
            }

            $result = array_filter($result);
        }

        return $result;
    }

    /**
     * @param int[] $spellIds
     *
     * @return Animation[][]
     */
    public function fetchAnimationsForSpells(array $spellIds): array
    {
        $baseUri = $this->client->getConfig('base_uri');

        $npcIds = [];
        $pool   = new Pool(
            $this->client,
            (static function (array $spellIds) use ($baseUri) {
                foreach ($spellIds as $spellId) {
                    yield $spellId => new Request('GET', $baseUri . 'spell=' . $spellId);
                }
            })($spellIds),
            [
                'concurrency' => 30,
                'fulfilled'   => static function (ResponseInterface $response, $spellId) use (&$npcIds) {
                    $html    = $response->getBody()->getContents();
                    $pattern = '#(\d+)}\)"\>View in 3D#i';
                    $matches = [];
                    if (preg_match_all($pattern, $html, $matches, PREG_SET_ORDER)) {
                        $npcIds[$spellId] = (int)$matches[0][1];
                    }
                },
            ]
        );
        $pool->promise()->wait();

        $files = [];
        $pool  = new Pool(
            $this->client,
            (static function (array $npcIds) {
                foreach ($npcIds as $spellId => $npcId) {
                    yield $spellId => new Request('GET', 'https://wow.zamimg.com/modelviewer/meta/npc/' . $npcId . '.json');
                }
            })($npcIds),
            [
                'concurrency' => 30,
                'fulfilled'   => static function (ResponseInterface $response, $spellId) use (&$files) {
                    $json = $response->getBody()->getContents();
                    $json = json_decode($json, false, 512, JSON_THROW_ON_ERROR);

                    if (empty($json->Model)) {
                        throw new RuntimeException('no model id from wowhead for: ' . $spellId);
                    }

                    $files[$spellId] = $json->Model . '.mo3';
                },
            ]
        );
        $pool->promise()->wait();


        $pool = new Pool(
            $this->client,
            (static function (array $files) {
                foreach ($files as $spellId => $file) {
                    $localFileName = 'MO3' . DIRECTORY_SEPARATOR . $file;
                    if (false === file_exists($localFileName)) {
                        yield $localFileName => new Request('GET', 'https://wow.zamimg.com/modelviewer/mo3/' . $file);
                    }
                }
            })($files),
            [
                'concurrency' => 30,
                'fulfilled'   => static function (ResponseInterface $response, $localFileName) {
                    file_put_contents($localFileName, $response->getBody()->getContents());
                },
            ]
        );
        $pool->promise()->wait();

        $animations = [];
        foreach ($files as $spellId => $file) {
            $localFileName = 'MO3' . DIRECTORY_SEPARATOR . $file;
            $stream        = fopen($localFileName, 'rb');
            $mo3Reader     = new MO3FileReader($stream);

            $animations[$spellId] = $mo3Reader->fetchAnimations();
            unset($mo3Reader);
        }

        return $animations;
    }

    public function fetchItemTooltip(int $itemId)
    {
        $body = $this->get('tooltip/item/' . $itemId . '&json&power');
        $json = json_decode($body, true, 512, JSON_THROW_ON_ERROR);
        return $json['tooltip'];
    }
}
