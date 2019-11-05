<?php

declare(strict_types=1);

namespace MJEGenerator;

class Mount
{
    private $name;
    private $spellId;
    private $icon;
    private $isItemTradable = false;
    private $mountSpecialLength = 0;

    public function __construct(
        string $name,
        int $spellId,
        string $icon = ''
    ) {
        $this->name    = $name;
        $this->spellId = $spellId;
        $this->icon    = $icon;
    }

    public function setMountSpecialLength(int $mountSpecialLength): self
    {
        $this->mountSpecialLength = $mountSpecialLength;

        return $this;
    }

    public function getName(): string
    {
        return $this->name;
    }

    public function getSpellId(): ?int
    {
        return $this->spellId;
    }

    public function setIcon(string $icon): self
    {
        $this->icon = $icon;
        return $this;
    }

    public function getIcon(): string
    {
        return $this->icon;
    }

    public function getMountSpecialLength(): int
    {
        return $this->mountSpecialLength;
    }

    public function setIsItemTradable(bool $isItemTradable): self
    {
        $this->isItemTradable = $isItemTradable;
        return $this;
    }

    public function isItemTradable(): bool
    {
        return $this->isItemTradable;
    }
}