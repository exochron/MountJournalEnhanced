<?php
declare(strict_types=1);

namespace MJEGenerator;

class Mount
{

    private $name = '';
    private $spellId = 0;
    private $creatureId = 0;
    private $itemIds = [];
    private $qualityId = 0;
    private $icon = '';
    private $isGround = false;
    private $isFlying = false;
    private $isAquatic = false;
    private $isJumping = false;
    private $isItemTradeable = false;
    private $mountSpecialLength = 0;

    public function __construct(
        string $name,
        int $spellId,
        int $creatureId = 0,
        int $qualityId = 0,
        string $icon = '',
        bool $isGround = false,
        bool $isFlying = false,
        bool $isAquatic = false,
        bool $isJumping = false,
        array $itemIds = []
    ) {
        $this->name       = $name;
        $this->spellId    = $spellId;
        $this->creatureId = $creatureId;
        $this->qualityId  = $qualityId;
        $this->icon       = $icon;
        $this->isGround   = $isGround;
        $this->isFlying   = $isFlying;
        $this->isAquatic  = $isAquatic;
        $this->isJumping  = $isJumping;
        $this->itemIds    = $itemIds;
    }

    public function setItemIds(array $items): self
    {
        $this->itemIds = $items;

        return $this;
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

    public function getSpellId(): int
    {
        return $this->spellId;
    }

    public function getCreatureId(): int
    {
        return $this->creatureId;
    }

    /**
     * @return int[]
     */
    public function getItemIds(): array
    {
        return $this->itemIds;
    }

    public function getQualityId(): int
    {
        return $this->qualityId;
    }

    public function getIcon(): string
    {
        return $this->icon;
    }

    public function isGround(): bool
    {
        return $this->isGround;
    }

    public function isFlying(): bool
    {
        return $this->isFlying;
    }

    public function isAquatic(): bool
    {
        return $this->isAquatic;
    }

    public function isJumping(): bool
    {
        return $this->isJumping;
    }

    public function getMountSpecialLength(): int
    {
        return $this->mountSpecialLength;
    }

    public function setIsItemTradeable(bool $isItemTradeable): self
    {
        $this->isItemTradeable = $isItemTradeable;
        return $this;
    }

    public function isItemTradeable(): bool
    {
        return $this->isItemTradeable;
    }
}