<?php
declare(strict_types=1);

namespace MJEGenerator\Wowhead;


use RuntimeException;

class MO3FileReader
{

    private $sourceStream;
    /** @var resource */
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

    /**
     * @param resource $stream
     */
    public function __construct($stream)
    {
        $this->sourceStream = $stream;
    }

    public function __destruct()
    {
        if (isset($this->uncompressedStream)) {
            fclose($this->uncompressedStream);
        }
        if (isset($this->sourceStream)) {
            fclose($this->sourceStream);
        }
    }

    private function readInt32($fp): int
    {
        return unpack('I', fread($fp, 4))[1];
    }

    private function readInt16($fp): int
    {
        return unpack('S', fread($fp, 2))[1];
    }

    private function readBool($fp): bool
    {
        return (bool)unpack('C', fread($fp, 1))[1];
    }

    private function readString($fp): string
    {
        $len = $this->readInt16($fp);

        return fread($fp, $len);
    }

    /**
     * @return resource
     * @throws Exception
     */
    private function extract()
    {
        // from https://wow.zamimg.com/modelviewer/viewer/viewer.min.js -> ZamModelViewer.Wow.Model.prototype.loadMo3

        if (null === $this->uncompressedStream) {
            $magic   = $this->readInt32($this->sourceStream);
            $version = $this->readInt32($this->sourceStream);

            $this->ofsVertices         = $this->readInt32($this->sourceStream);
            $this->ofsIndices          = $this->readInt32($this->sourceStream);
            $this->ofsSequences        = $this->readInt32($this->sourceStream);
            $this->ofsAnimations       = $this->readInt32($this->sourceStream);
            $this->ofsAnimLookup       = $this->readInt32($this->sourceStream);
            $this->ofsBones            = $this->readInt32($this->sourceStream);
            $this->ofsBoneLookup       = $this->readInt32($this->sourceStream);
            $this->ofsKeyBoneLookup    = $this->readInt32($this->sourceStream);
            $this->ofsMeshes           = $this->readInt32($this->sourceStream);
            $this->ofsTexUnits         = $this->readInt32($this->sourceStream);
            $this->ofsTexUnitLookup    = $this->readInt32($this->sourceStream);
            $this->ofsRenderFlags      = $this->readInt32($this->sourceStream);
            $this->ofsMaterials        = $this->readInt32($this->sourceStream);
            $this->ofsMaterialLookup   = $this->readInt32($this->sourceStream);
            $this->ofsTextureAnims     = $this->readInt32($this->sourceStream);
            $this->ofsTexAnimLookup    = $this->readInt32($this->sourceStream);
            $this->ofsTexReplacements  = $this->readInt32($this->sourceStream);
            $this->ofsAttachments      = $this->readInt32($this->sourceStream);
            $this->ofsAttachmentLookup = $this->readInt32($this->sourceStream);
            $this->ofsColors           = $this->readInt32($this->sourceStream);
            $this->ofsAlphas           = $this->readInt32($this->sourceStream);
            $this->ofsAlphaLookup      = $this->readInt32($this->sourceStream);
            $this->ofsParticleEmitters = $this->readInt32($this->sourceStream);
            $this->ofsRibbonEmitters   = $this->readInt32($this->sourceStream);
            $ofsExp2                   = $this->readInt32($this->sourceStream);
            $uncompressedSize          = $this->readInt32($this->sourceStream);

            $compressedData = '';
            while ($chunk = fread($this->sourceStream, 1048576)) {
                $compressedData .= $chunk;
            }
            fclose($this->sourceStream);
            $this->sourceStream = null;

            $uncompressedData = zlib_decode($compressedData);

            if (false === $uncompressedData || strlen($uncompressedData) !== $uncompressedSize) {
                var_dump($uncompressedSize, $compressedData);
                throw new RuntimeException('Corrupted MO3File');
            }

            $this->uncompressedStream = fopen('php://memory', 'rb+');
            fwrite($this->uncompressedStream, $uncompressedData);
            fseek($this->uncompressedStream, 0);
        }

        return $this->uncompressedStream;
    }

    /**
     * @return Animation[]
     */
    public function fetchAnimations(): array
    {
        $stream = $this->extract();
        fseek($stream, $this->ofsAnimations);
        $numAnims   = $this->readInt32($stream);
        $animations = [];

        for ($i = 0; $i < $numAnims; $i++) {
            $animation = new Animation(
                $this->readInt16($stream),
                $this->readInt16($stream),
                $this->readInt32($stream),
                $this->readInt32($stream),
                $this->readInt16($stream),
                $this->readInt16($stream),
                $this->readInt16($stream),
                $this->readInt16($stream),
                $this->readInt16($stream),
                $this->readBool($stream),
            );

            if ($animation->isAvailable()) {
                $animation->setName($this->readString($stream));
            }

            $animations[] = $animation;
        }

        return $animations;
    }
}