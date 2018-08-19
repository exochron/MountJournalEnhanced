<?php

namespace MJEGenerator\WarcraftMounts;


class Requester
{
    /**
     * @return string[] mount name => family name
     */
    public function fetchMountFamilies(): array
    {
        $result = [];
        $html = file_get_contents('http://www.warcraftmounts.com/gallery.php');

        preg_match_all("#<h5><a .*</div>\s+</span>#isU", $html, $htmlParts);
        foreach ($htmlParts[0] as $htmlPart) {

            preg_match("#<h5><a id=\'(.*)\'>#isU", $htmlPart, $familyName);

            preg_match_all("#<img class=\'thumbimage\' src=\'.*\' alt=\'(.*)\' />#isU", $htmlPart, $names);
            foreach ($names[1] as $name) {
                $name = html_entity_decode($name, ENT_QUOTES | ENT_XML1);
                $name = strtolower($name);
                $name = str_replace([' [horde]', ' [alliance]'], '', $name);
                $result[$name] = $familyName[1];
            }
        }

        return $result;
    }
}