<?php
declare(strict_types=1);

namespace MJEGenerator\Battlenet;

use Amp\Artax\DefaultClient;
use Amp\Artax\FormBody;
use Amp\Artax\Request;
use Amp\Artax\Response;
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

    private $client;
    private $accessToken = [];
    private $clientId;
    private $clientSecret;

    public function __construct(string $clientId, string $clientSecret)
    {
        $this->client       = new DefaultClient;
        $this->clientId     = $clientId;
        $this->clientSecret = $clientSecret;
    }

    /**
     * @param string $region
     *
     * @return Mount[]
     */
    public function fetchMounts(string $region = self::REGION_EU)
    {
        $result = [];

        $data = yield from $this->call($region, 'mount');
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

    private function call(string $region, string $resource)
    {
        $token = $this->accessToken[$region] ?? '';

        if ('' === $token) {
            $token = $this->accessToken[$region] = yield from $this->fetchAuthToken($region);
        }

        $url     = self::ENDPOINT[$region] . '/wow/' . $resource . '/';
        $url     .= '?locale=' . self::LOCALES[$region];
        $request = new Request($url);
        $request = $request->withHeader('Authorization', 'Bearer ' . $token);

        var_dump($url . '&access_token=' . $token, $token);

        /** @var Response $response */
        $response = yield $this->client->request($request);
        $body     = yield $response->getBody();

        return json_decode($body, true);
    }

    private function fetchAuthToken(string $region)
    {
        $form = new FormBody;
        $form->addField('grant_type', 'client_credentials');

        $request = (new Request('https://' . $region . '.battle.net/oauth/token', 'POST'))
            ->withHeader(
                'Authorization',
                'Basic ' . base64_encode($this->clientId . ':' . $this->clientSecret)
            )->withBody($form);

        /** @var Response $response */
        $response = yield $this->client->request($request);
        $body     = yield $response->getBody();
        $result   = json_decode($body, true);
        return $result['access_token'];
    }
}