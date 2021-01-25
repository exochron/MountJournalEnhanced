### 2.10.1 - Tainted Love
During MountJournal_OnShow() ``currentItem`` gets tainted [cf67]. (Probably ``SlotButton`` as well [cf62].)
- One Idea is to remove the hooks on ``C_MountJournal`` so that ``MountJournal_FullUpdate()`` can run untainted.
- Next Idea is to initialize the UI not during ``ADDON_LOADED`` but only on the first ``OnShow`` of the MountJournal.


### Next
- automatic favor new mounts 
- switch through mount variation (eg. High Priest's Lightsworn Seeker: C_MountJournal.GetMountAllCreatureDisplayInfoByID(861))

### More Ideas:
- more animation control in display (start/pause, movements, with sound effects)
- color filter
- variation filter (undead, mech, elemental, magic...)
- option: auto favorite new mounts; even those learned during offline time/on alts
- favorite groups / custom filter groups
- favorite menu at SummonRandomFavoriteButton?