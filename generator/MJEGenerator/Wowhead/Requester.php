<?php


namespace MJEGenerator\Wowhead;


class Requester
{

    /**
     * @return int[][] spellId => itemIds
     */
    public function fetchMountItems(): array
    {
        $result = [];
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

}