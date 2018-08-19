<?php


namespace MJEGenerator\Convert;

use MJEGenerator\Mount;

class LuaExport
{
    /**
     * @param string $variableName
     * @param Mount[][] $mounts
     * @return string
     */
    public function toLuaCategories(string $variableName, array $mounts): string
    {
        return $this->prepareHead($variableName)
            . $this->toCategory($mounts)
            . '}';
    }

    private function prepareHead(string $variableName): string
    {
        return 'local ADDON_NAME, ADDON = ...' . PHP_EOL . PHP_EOL
            . 'ADDON.' . $variableName . ' = {' . PHP_EOL;
    }

    /**
     * @param Mount[][] $mounts
     * @return string
     */
    private function toCategory(array $mounts): string
    {
        $result = '';
        foreach ($mounts as $category => $list) {
            $result .= '["' . $category . '"] = {' . PHP_EOL;
            if (reset($list) instanceof Mount) {
                foreach ($list as $key => $mount) {
                    $result .= '[' . $key . '] = true, -- ' . $mount->getName() . PHP_EOL;
                }
            } else {
                $result .= $this->toCategory($list);
            }

            $result .= '},' . PHP_EOL;
        }

        return $result;
    }

    /**
     * @param string $variableName
     * @param Mount[] $mounts
     * @return string
     */
    public function toLuaSpellList(string $variableName, array $mounts): string
    {
        $result = $this->prepareHead($variableName);
        foreach ($mounts as $key => $mount) {
            $result .= '[' . $key . '] = ' . $mount->getSpellId() . ', -- ' . $mount->getName() . PHP_EOL;
        }

        return $result . '}';
    }
}