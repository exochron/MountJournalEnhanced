<?php


namespace MJEGenerator\Battlenet;

use MJEGenerator\Mount;

class Requester
{
    const REGION_US = 'us';
    const REGION_EU = 'eu';

    private const LOCALES = [
        self::REGION_EU => 'en_GB',
        self::REGION_US => 'en_US',
    ];

    private const CORRECT_SPELLID = [
        "Mecha-Mogul Mk2" => 261437
    ];
    private const CORRECT_ITEMID = [
        261437 => 161134
    ];

    private const SPELL_BLACKLIST = [
        244457 => 'Default AI Mount Record',
    ];

    private $apiKey;

    public function __construct(string $apiKey)
    {
        $this->apiKey = $apiKey;
    }

    /**
     * @param string $region
     * @return Mount[]
     */
    public function fetchMounts(string $region = self::REGION_EU): array
    {
        $result = [];

        $data = $this->call($region, 'mount');
        foreach ($data['mounts'] ?? [] as $item) {
            if (empty($item['spellId']) && isset(self::CORRECT_SPELLID[$item['name']])) {
                $item['spellId'] = self::CORRECT_SPELLID[$item['name']];
            }
            if (empty($item['itemId']) && isset(self::CORRECT_ITEMID[$item['spellId']])) {
                $item['itemId'] = self::CORRECT_ITEMID[$item['spellId']];
            }

            if (false === isset(self::SPELL_BLACKLIST[$item['spellId']])) {
                $result[$item['spellId']] = new Mount($item);
            }
        }

        return $result;
    }

    private function call(string $region, string $resource): array
    {
        $url = 'https://' . $region . '.api.battle.net/wow/' . $resource . '/';
        $url .= '?locale=' . self::LOCALES[$region];
        $url .= '&apiKey=' . $this->apiKey;

        $response = file_get_contents($url);

        return json_decode($response, true);
    }

}