<?php
declare(strict_types=1);

namespace MJEGenerator\Wowhead;


use MJEGenerator\Mount;

class Requester
{

    /**
     * @return int[][] spellId => itemIds
     */
    public function fetchMountItems(): array
    {
        $result  = [];
        $matches = [];
        $html    = file_get_contents('http://www.wowhead.com/mount-spells/live-only:on');
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
     * @return Animation[]
     */
    public function fetchAnimationsBySpellId(int $spellId): array
    {
        $html = file_get_contents('https://www.wowhead.com/spell=' . $spellId);

        $pattern = '#onclick="ModelViewer.show\(.*displayId: (\d+),?.*}\)"\>View in 3D#is';
        $matches = [];
        if (preg_match_all($pattern, $html, $matches, PREG_SET_ORDER)) {
            $json = file_get_contents('https://wow.zamimg.com/modelviewer/meta/npc/' . $matches[0][1] . '.json');
            $json = json_decode($json);

            if (empty($json->Model)) {
                throw new \Exception('no model id from wowhead for: ' . $spellId);
            }

            $fileName      = $json->Model . '.mo3';
            $localFileName = 'MO3' . DIRECTORY_SEPARATOR . $fileName;
            if (false === file_exists($localFileName)) {
                $mo3File = file_get_contents('https://wow.zamimg.com/modelviewer/mo3/' . $fileName);
                file_put_contents($localFileName, $mo3File);
            }

            $stream    = fopen($localFileName, 'r');
            $mo3Reader = new MO3FileReader($stream);

            return $mo3Reader->fetchAnimations();
        }

        return [];
    }
}