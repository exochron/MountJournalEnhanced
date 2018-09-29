<?php
declare(strict_types=1);

namespace MJEGenerator\Wowhead;


class Animation
{
    private $id;
    private $subId;
    private $flags;
    private $length;
    private $next;
    private $index;
    private $available;
    private $name;

    public function __construct(
        int $id,
        int $subId,
        int $flags,
        int $length,
        int $next,
        int $index,
        bool $available
    ) {
        $this->id        = $id;
        $this->subId     = $subId;
        $this->flags     = $flags;
        $this->length    = $length;
        $this->next      = $next;
        $this->index     = $index;
        $this->available = $available;
    }

    public function setName(string $name): self
    {
        $this->name = $name;
        return $this;
    }

    public function getId(): int
    {
        return $this->id;
    }

    public function getSubId(): int
    {
        return $this->subId;
    }

    public function getFlags(): int
    {
        return $this->flags;
    }

    public function getLength(): int
    {
        return $this->length;
    }

    public function getNext(): int
    {
        return $this->next;
    }

    public function getIndex(): int
    {
        return $this->index;
    }

    public function isAvailable(): bool
    {
        return $this->available;
    }

    public function getName(): string
    {
        return $this->name;
    }
}