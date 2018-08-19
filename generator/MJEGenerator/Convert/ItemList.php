<?php

namespace MJEGenerator\Convert;

use MJEGenerator\Mount;

class ItemList
{

    /**
     * @param Mount[] $mounts
     * @return Mount[]
     */
    public function listMountsByItemIds(array $mounts): array
    {
        $result = [];

        foreach ($mounts as $mount) {
            foreach ($mount->getItemIds() as $itemId) {
                $result[$itemId] = $mount;
            }
        }

        return $result;
    }
}