<?php


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

    public function __construct(array $data)
    {
        $this->name       = $data['name'];
        $this->spellId    = $data['spellId'];
        $this->creatureId = $data['creatureId'];
        $this->qualityId  = $data['qualityId'];
        $this->icon       = $data['icon'];
        $this->isGround   = $data['isGround'];
        $this->isFlying   = $data['isFlying'];
        $this->isAquatic  = $data['isAquatic'];
        $this->isJumping  = $data['isJumping'];

        if (false === empty($data['itemId'])) {
            $this->itemIds = [$data['itemId']];
        }
    }

    public function setItemIds(array $items): self
    {
        $this->itemIds = $items;

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
}