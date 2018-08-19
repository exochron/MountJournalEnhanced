<?php


namespace MJEGenerator\Convert;


use MJEGenerator\Mount;

class Family
{
    private $config = [];
    private $ignoredMounts;

    public function __construct(array $config, array $ignoredMounts)
    {
        $this->config = $this->prepareConfig($config);
        $this->ignoredMounts = array_flip($ignoredMounts);
    }

    /**
     * @param Mount[] $mounts
     * @param string[] $wcmMountMap
     * @return Mount[][]
     */
    public function groupMountsByFamily(array $mounts, array $wcmMountMap): array
    {
        $result = [];
        foreach ($mounts as $mount) {

            $spellId = $mount->getSpellId();

            // check for spellId in config
            foreach ($this->config as $mainFamily => $mainConfig) {
                if (isset($mainConfig['wcm'])) {
                    if ($mainConfig[$spellId]) {
                        $result[$mainFamily][$spellId] = $mount;
                        continue 2;
                    }
                } else {
                    foreach ($mainConfig as $subFamily => $subConfig) {
                        if ($subConfig[$spellId]) {
                            $result[$mainFamily][$subFamily][$spellId] = $mount;
                            continue 3;
                        }
                    }
                }
            }

            // check by family name
            $wcmFamily = $wcmMountMap[strtolower($mount->getName())] ?? null;
            if (null === $wcmFamily) {
                if(false === isset($this->ignoredMounts[$spellId])) {
                    throw new \Exception('mount not available on warcraftmounts: ' . $mount->getName() . ' (' . $mount->getSpellId() . '; ' . $mount->getIcon() . ')');
                }
            } else {
                $matched = false;
                foreach ($this->config as $mainFamily => $mainConfig) {
                    if (isset($mainConfig['wcm'])) {
                        if ($this->doesMatch($mount, $wcmFamily, $mainConfig)) {
                            $result[$mainFamily][$spellId] = $mount;
                            $matched = true;
                        }
                    } else {
                        foreach ($mainConfig as $subFamily => $subConfig) {
                            if ($this->doesMatch($mount, $wcmFamily, $subConfig)) {
                                $result[$mainFamily][$subFamily][$spellId] = $mount;
                                $matched = true;
                            }
                        }
                    }
                }

                if (false === $matched) {
                    throw new \Exception('no Family found for ' . $mount->getName() . ' (' . $mount->getSpellId() . '; ' . $mount->getIcon() . '; ' . $wcmFamily . ')');
                }
            }
        }

        ksort($result);
        foreach ($result as &$subResult) {
            ksort($subResult);
        }

        return $result;
    }

    private function prepareConfig(array $config): array
    {
        foreach ($config as $familyKey => $familyConf) {
            if (isset($familyConf['icons'])) {
                $config[$familyKey]['icons'] = '/' . implode('|', $familyConf['icons']) . '/i';
            }

            if (isset($familyConf['wcm'])) {
                $config[$familyKey]['wcm'] = array_flip($familyConf['wcm']);
            } elseif (isset($familyConf[0])) {
                $config[$familyKey] = ['wcm' => array_flip($familyConf)];
            } else {
                $config[$familyKey] = $this->prepareConfig($familyConf);
            }
        }

        return $config;
    }

    private function doesMatch(Mount $mount, string $wcmFamily, array $subConfig): bool
    {
        $wcmList = $subConfig['wcm'];
        if (isset($wcmList[$wcmFamily])) {
            $iconPattern = $subConfig['icons'] ?: null;
            if (null === $iconPattern || preg_match($iconPattern, $mount->getIcon())) {
                return true;
            }
        }

        return false;
    }
}