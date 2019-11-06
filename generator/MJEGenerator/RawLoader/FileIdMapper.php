<?php

declare(strict_types=1);

namespace MJEGenerator\RawLoader;

use SplFileObject;

class FileIdMapper
{
    private $iconMap = [];

    public function __construct(string $idListFile)
    {
        $file = new SplFileObject($idListFile, 'r', true);
        $file->setFlags(SplFileObject::READ_CSV);
        $file->setCsvControl(';');

        foreach ($file as $record) {
            if (preg_match('#interface/icons/(.*)\.blp#i', $record[1], $matches)) {
                $this->iconMap[(int)$record[0]] = $matches[1];
            }
        }
    }

    public function fetchIcon(int $fileId): string
    {
        return $this->iconMap[$fileId];
    }
}
