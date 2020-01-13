<?php

declare(strict_types=1);

namespace MJEGenerator\RawLoader;


class CsvReader
{
    private $baseDir;
    private $sparseCache = [];

    public function __construct(string $baseDir)
    {
        $this->baseDir = $baseDir;
    }

    public function iterateMount(): iterable
    {
        yield from $this->iterateFile('mount.csv');
    }

    private function iterateFile(string $fileName): iterable
    {
        $header = [];

        $file = new \SplFileObject($this->baseDir . $fileName);
        $file->setFlags(\SplFileObject::DROP_NEW_LINE | \SplFileObject::SKIP_EMPTY | \SplFileObject::READ_CSV);
        foreach ($file as $row) {
            if ([] === $header) {
                $header = $row;
            } else {
                yield array_combine($header, $row);
            }
        }
    }

    public function iterateSpellMisc(): iterable
    {
        yield from $this->iterateFile('spellmisc.csv');
    }

    public function iterateItemEffect(): iterable
    {
        yield from $this->iterateFile('itemeffect.csv');
    }

    public function fetchItemSparse(int $itemId): ?array
    {
        if ([] === $this->sparseCache) {
            foreach ($this->iterateFile('itemsparse.csv') as $row) {
                $this->sparseCache[$row['ID']] = $row;
            }
        }

        return $this->sparseCache[$itemId] ?? [];
    }

}