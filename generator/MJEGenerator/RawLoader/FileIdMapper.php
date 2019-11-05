<?php

declare(strict_types=1);

namespace MJEGenerator\RawLoader;

use SplFileObject;

class FileIdMapper
{
    private $file;
    private $fileMap = [];

    public function __construct(string $idListFile)
    {
        $this->file = new SplFileObject($idListFile, 'r', true);
        $this->file->setFlags(SplFileObject::READ_CSV);
        $this->file->setCsvControl(';');

        foreach ($this->file as $record) {
            $this->fileMap[(int)$record[0]] = $record[1];
        }
    }

    public function fetchIcon(int $fileId): string
    {
        $path = $this->fetchFile($fileId);

        // trim interface/icons/ and .blp
        return substr($path, 16, -4);
    }

    public function fetchFile(int $fileId): string
    {
        return $this->fileMap[$fileId];
    }
}
