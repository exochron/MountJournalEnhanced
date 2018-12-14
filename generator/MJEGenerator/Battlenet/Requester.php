<?php
declare(strict_types=1);

namespace MJEGenerator\Battlenet;

use MJEGenerator\Mount;

class Requester
{
    public const REGION_US = 'us';
    public const REGION_EU = 'eu';

    private const ENDPOINT = [
        self::REGION_EU => 'https://eu.api.blizzard.com',
        self::REGION_US => 'https://us.api.blizzard.com',
    ];

    private const LOCALES = [
        self::REGION_EU => 'en_GB',
        self::REGION_US => 'en_US',
    ];

    private $accessToken = [];
    private $clientId;
    private $clientSecret;

    public function __construct(string $clientId, string $clientSecret)
    {
        $this->clientId     = $clientId;
        $this->clientSecret = $clientSecret;
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
            $result[$item['spellId']] = new Mount(
                $item['name'],
                $item['spellId'],
                $item['creatureId'],
                $item['qualityId'],
                $item['icon'] ?? '',
                $item['isGround'],
                $item['isFlying'],
                $item['isAquatic'],
                $item['isJumping'],
                $item['itemId'] > 0 ? [$item['itemId']] : []
            );
        }

        return $result;
    }

    private function call(string $region, string $resource): array
    {
        $token = $this->accessToken[$region];

        if (empty($token)) {
            $token = $this->accessToken[$region] = $this->oAauthToken($region);
        }

        $url = self::ENDPOINT[$region] . '/wow/' . $resource . '/';
        $url .= '?locale=' . self::LOCALES[$region];

        $options = [
            'http' => [
                'header' => [
                    "Authorization: Bearer " . $token,
                ],
                'method' => 'GET',
            ],
        ];
        $context = stream_context_create($options);
        $response = file_get_contents($url, false, $context);

        return json_decode($response, true);
    }

    private function oAauthToken(string $region)
    {
        $options = [
            'http' => [
                'header'  => [
                    "Authorization: Basic " . base64_encode($this->clientId . ':' . $this->clientSecret),
                ],
                'method'  => 'POST',
                'content' => http_build_query([
                    'grant_type' => 'client_credentials',
                ]),
            ],
        ];
        $context = stream_context_create($options);
        $result  = file_get_contents('https://' . $region . '.battle.net/oauth/token', false, $context);
        $result  = json_decode($result, true);
        return $result['access_token'];
    }
}