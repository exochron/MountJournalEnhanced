<?php
declare(strict_types=1);

namespace MJEGenerator\Wowhead;


use Amp\File\Handle;
use function Amp\File\open;
use Generator;
use RuntimeException;

class MO3FileReader
{

    private $sourceStream;
    /** @var Handle */
    private $uncompressedStream;

    private $ofsVertices;
    private $ofsIndices;
    private $ofsSequences;
    private $ofsAnimations;
    private $ofsAnimLookup;
    private $ofsBones;
    private $ofsBoneLookup;
    private $ofsKeyBoneLookup;
    private $ofsMeshes;
    private $ofsTexUnits;
    private $ofsTexUnitLookup;
    private $ofsRenderFlags;
    private $ofsMaterials;
    private $ofsMaterialLookup;
    private $ofsTextureAnims;
    private $ofsTexAnimLookup;
    private $ofsTexReplacements;
    private $ofsAttachments;
    private $ofsAttachmentLookup;
    private $ofsColors;
    private $ofsAlphas;
    private $ofsAlphaLookup;
    private $ofsParticleEmitters;
    private $ofsRibbonEmitters;

    public function __construct(Handle $stream)
    {
        $this->sourceStream = $stream;
    }

    public function __destruct()
    {
        if (isset($this->sourceStream)) {
            $this->sourceStream->close();
        }
        if (isset($this->uncompressedStream)) {
            $this->uncompressedStream->close();
        }
    }

    private function getInt32(Handle $fp)
    {
        return unpack('I', yield $fp->read( 4))[1];
    }

    private function getInt16(Handle $fp)
    {
        return unpack('S', yield $fp->read( 2))[1];
    }

    private function getBool(Handle $fp)
    {
        return (bool)unpack('C', yield $fp->read( 1))[1];
    }

    private function getString(Handle $fp): Generator
    {
        $len = yield from $this->getInt16($fp);

        return yield $fp->read( $len);
    }

    /**
     * @return Handle|Generator
     * @throws Exception
     */
    private function extract()
    {
        if (null === $this->uncompressedStream) {
            $magic   = yield from $this->getInt32($this->sourceStream);
            $version = yield from $this->getInt32($this->sourceStream);

            $this->ofsVertices         = yield from $this->getInt32($this->sourceStream);
            $this->ofsIndices          = yield from $this->getInt32($this->sourceStream);
            $this->ofsSequences        = yield from $this->getInt32($this->sourceStream);
            $this->ofsAnimations       = yield from $this->getInt32($this->sourceStream);
            $this->ofsAnimLookup       = yield from $this->getInt32($this->sourceStream);
            $this->ofsBones            = yield from $this->getInt32($this->sourceStream);
            $this->ofsBoneLookup       = yield from $this->getInt32($this->sourceStream);
            $this->ofsKeyBoneLookup    = yield from $this->getInt32($this->sourceStream);
            $this->ofsMeshes           = yield from $this->getInt32($this->sourceStream);
            $this->ofsTexUnits         = yield from $this->getInt32($this->sourceStream);
            $this->ofsTexUnitLookup    = yield from $this->getInt32($this->sourceStream);
            $this->ofsRenderFlags      = yield from $this->getInt32($this->sourceStream);
            $this->ofsMaterials        = yield from $this->getInt32($this->sourceStream);
            $this->ofsMaterialLookup   = yield from $this->getInt32($this->sourceStream);
            $this->ofsTextureAnims     = yield from $this->getInt32($this->sourceStream);
            $this->ofsTexAnimLookup    = yield from $this->getInt32($this->sourceStream);
            $this->ofsTexReplacements  = yield from $this->getInt32($this->sourceStream);
            $this->ofsAttachments      = yield from $this->getInt32($this->sourceStream);
            $this->ofsAttachmentLookup = yield from $this->getInt32($this->sourceStream);
            $this->ofsColors           = yield from $this->getInt32($this->sourceStream);
            $this->ofsAlphas           = yield from $this->getInt32($this->sourceStream);
            $this->ofsAlphaLookup      = yield from $this->getInt32($this->sourceStream);
            $this->ofsParticleEmitters = yield from $this->getInt32($this->sourceStream);
            $this->ofsRibbonEmitters   = yield from $this->getInt32($this->sourceStream);
            $uncompressedSize          = yield from $this->getInt32($this->sourceStream);

            $compressedData = '';
            while (null !== $chunk = yield $this->sourceStream->read()) {
                $compressedData .= $chunk;
            }
            yield $this->sourceStream->close();

            $uncompressedData = zlib_decode($compressedData);

            if (strlen($uncompressedData) !== $uncompressedSize) {
                throw new RuntimeException('Corrupted MO3File');
            }

            $this->uncompressedStream = yield open('php://memory', 'r+');
            yield $this->uncompressedStream->write($uncompressedData);
            yield $this->uncompressedStream->seek(0);
        }

        return $this->uncompressedStream;
    }

    /**
     * @return Animation[]|Generator
     */
    public function fetchAnimations(): Generator
    {
        /** @var Handle $stream */
        $stream = yield from $this->extract();
        yield $stream->seek($this->ofsAnimations);
        $numAnims   = yield from $this->getInt32($stream);
        $animations = [];

        for ($i = 0; $i < $numAnims; $i++) {
            $animation = new Animation(
                yield from $this->getInt16($stream),
                yield from $this->getInt16($stream),
                yield from $this->getInt32($stream),
                yield from $this->getInt32($stream),
                yield from $this->getInt16($stream),
                yield from $this->getInt16($stream),
                yield from $this->getBool($stream),
            );

            if ($animation->isAvailable()) {
                $animation->setName(yield from $this->getString($stream));
            }

            $animations[] = $animation;
        }

        return $animations;
    }
}