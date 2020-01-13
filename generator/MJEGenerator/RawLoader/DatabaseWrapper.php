<?php

declare(strict_types=1);

namespace MJEGenerator\RawLoader;


class DatabaseWrapper
{
    private $db2Reader;
    private $csvReader;
    private $extractDir;
    private $useDB2ForSparse = null;

    public function __construct(string $cacheDir, string $extractDir)
    {
        $this->extractDir = $extractDir . '/dbfilesclient/';
        $this->db2Reader  = new DB2Reader($cacheDir, $this->extractDir);
        $this->csvReader  = new CsvReader($extractDir);
    }

    public function iterateMount(): iterable
    {
        if (file_exists($this->extractDir . 'Mount.db2')) {
            yield from $this->db2Reader->iterateMount();
        } else {
            yield from $this->csvReader->iterateMount();
        }
    }

    public function iterateSpellMisc(): iterable
    {
        if (file_exists($this->extractDir . 'SpellMisc.db2')) {
            yield from $this->db2Reader->iterateSpellMisc();
        } else {
            yield from $this->csvReader->iterateSpellMisc();
        }
    }

    public function iterateItemEffect(): iterable
    {
        if (file_exists($this->extractDir . 'ItemEffect.db2')) {
            yield from $this->db2Reader->iterateItemEffect();
        } else {
            yield from $this->csvReader->iterateItemEffect();
        }
    }

    public function fetchItemSparse(int $itemId): ?array
    {
        if (null === $this->useDB2ForSparse) {
            $this->useDB2ForSparse = file_exists($this->extractDir . 'ItemSparse.db2');
        }

        if ($this->useDB2ForSparse) {
            return $this->db2Reader->fetchItemSparse($itemId);
        }

        return $this->csvReader->fetchItemSparse($itemId);
    }
}