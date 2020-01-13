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

    private function iterateFile(string $fileName): \Generator
    {
        $header = [];

        $file = new \SplFileObject($this->baseDir . $fileName);
        $file->setFlags(\SplFileObject::DROP_NEW_LINE | \SplFileObject::SKIP_EMPTY | \SplFileObject::READ_CSV);
        foreach ($file as $row) {
            if (empty($row)) {
                continue;
            }
            if ([] === $header) {
                $header = $row;
            } else {
                $data = array_combine($header, $row);
                if (isset($data['ID'])) {
                    yield $data['ID'] => $data;
                } else {
                    yield $data;
                }
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
            $this->sparseCache = iterator_to_array($this->iterateFile('itemsparse.csv'));
        }

        return $this->sparseCache[$itemId] ?? null;
    }

}