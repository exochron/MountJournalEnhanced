<?php
declare(strict_types=1);

namespace MJEGenerator;

class Mount
{

    private $name;
    private $spellId;
    private $creatureId;
    private $itemIds;
    private $qualityId;
    private $icon;
    private $isGround;
    private $isFlying;
    private $isAquatic;
    private $isJumping;
    private $isItemTradable = false;
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

    public function mergeTogether(Mount $source): self
    {
        $this->name    = $source->getName();
        $this->spellId = $source->getSpellId();

        if ($source->getCreatureId()) {
            $this->creatureId = $source->getCreatureId();
        }
        if ($source->getQualityId()) {
            $this->qualityId = $source->getQualityId();
        }
        if ($source->getIcon()) {
            $this->icon = $source->getIcon();
        }
        if ($source->isGround()) {
            $this->isGround = $source->isGround();
        }
        if ($source->isFlying()) {
            $this->isFlying = $source->isFlying();
        }
        if ($source->isAquatic()) {
            $this->isAquatic = $source->isAquatic();
        }
        if ($source->isJumping()) {
            $this->isJumping = $source->isJumping();
        }
        if ($source->isItemTradable()) {
            $this->isItemTradable = $source->isItemTradable();
        }
        if ([] !== $source->getItemIds()) {
            $this->itemIds = $source->getItemIds();
        }
        if ($source->getMountSpecialLength()) {
            $this->mountSpecialLength = $source->getMountSpecialLength();
        }

        return $this;
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