<?php


namespace MJEGenerator\Wowhead;


class MO3FileReader
{

    private $sourceStream;
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

    public function __construct($stream)
    {
        $this->sourceStream = $stream;
    }

    public function __destruct()
    {
        if (is_resource($this->sourceStream)) {
            fclose($this->sourceStream);
        }
        if (is_resource($this->uncompressedStream)) {
            fclose($this->uncompressedStream);
        }
    }

    private function getInt32($fp)
    {
        return unpack("I", fread($fp, 4))[1];
    }

    private function getInt16($fp)
    {
        return unpack("S", fread($fp, 2))[1];
    }

    private function getBool($fp)
    {
        return (bool)unpack("C", fread($fp, 1))[1];
    }

    private function getString($fp)
    {
        $len = $this->getInt16($fp);

        return fread($fp, $len);
    }

    private function extract()
    {
        if (null === $this->uncompressedStream) {
            $magic   = $this->getInt32($this->sourceStream);
            $version = $this->getInt32($this->sourceStream);

            $this->ofsVertices         = $this->getInt32($this->sourceStream);
            $this->ofsIndices          = $this->getInt32($this->sourceStream);
            $this->ofsSequences        = $this->getInt32($this->sourceStream);
            $this->ofsAnimations       = $this->getInt32($this->sourceStream);
            $this->ofsAnimLookup       = $this->getInt32($this->sourceStream);
            $this->ofsBones            = $this->getInt32($this->sourceStream);
            $this->ofsBoneLookup       = $this->getInt32($this->sourceStream);
            $this->ofsKeyBoneLookup    = $this->getInt32($this->sourceStream);
            $this->ofsMeshes           = $this->getInt32($this->sourceStream);
            $this->ofsTexUnits         = $this->getInt32($this->sourceStream);
            $this->ofsTexUnitLookup    = $this->getInt32($this->sourceStream);
            $this->ofsRenderFlags      = $this->getInt32($this->sourceStream);
            $this->ofsMaterials        = $this->getInt32($this->sourceStream);
            $this->ofsMaterialLookup   = $this->getInt32($this->sourceStream);
            $this->ofsTextureAnims     = $this->getInt32($this->sourceStream);
            $this->ofsTexAnimLookup    = $this->getInt32($this->sourceStream);
            $this->ofsTexReplacements  = $this->getInt32($this->sourceStream);
            $this->ofsAttachments      = $this->getInt32($this->sourceStream);
            $this->ofsAttachmentLookup = $this->getInt32($this->sourceStream);
            $this->ofsColors           = $this->getInt32($this->sourceStream);
            $this->ofsAlphas           = $this->getInt32($this->sourceStream);
            $this->ofsAlphaLookup      = $this->getInt32($this->sourceStream);
            $this->ofsParticleEmitters = $this->getInt32($this->sourceStream);
            $this->ofsRibbonEmitters   = $this->getInt32($this->sourceStream);
            $uncompressedSize           = $this->getInt32($this->sourceStream);

            $compressedData = stream_get_contents($this->sourceStream);
            fclose($this->sourceStream);

            $uncompressedData = zlib_decode($compressedData);

            if (strlen($uncompressedData) !== $uncompressedSize) {
                throw new \Exception('Corrupted MO3File');
            }

            $this->uncompressedStream = fopen('php://memory', 'r+');
            fwrite($this->uncompressedStream, $uncompressedData);
            rewind($this->uncompressedStream);
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
        $numAnims   = $this->getInt32($stream);
        $animations = [];

        for ($i = 0; $i < $numAnims; $i++) {
            $animation = new Animation(
                $this->getInt16($stream),
                $this->getInt16($stream),
                $this->getInt32($stream),
                $this->getInt32($stream),
                $this->getInt16($stream),
                $this->getInt16($stream),
                $this->getBool($stream)
            );

            if ($animation->isAvailable()) {
                $animation->setName($this->getString($stream));
            }

            $animations[] = $animation;
        }

        return $animations;
    }
}