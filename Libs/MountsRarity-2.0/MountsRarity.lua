--[[----------------------------------------------------------------------------

  MountsRarity/MountsRarity.lua
  Provides rarity data for mounts among the playerbase.

  Copyright (c) 2023 Sören Gade

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <https://www.gnu.org/licenses/>.

----------------------------------------------------------------------------]]--

-- This build version gets automatically updated.
local MINOR = 678
---@class MountsRarity: { GetData: function, GetRarityByID: function }
local MountsRarity = LibStub:NewLibrary("MountsRarity-2.0", MINOR)
if not MountsRarity then return end -- already loaded and no upgrade necessary

local lazyLoadData = function()
  return {}
end
local data

function MountsRarity:GetData()
  if not data then
    data = lazyLoadData()
  end

  ---@type table<number, number|nil>
  return data
end

---Returns the rarity of a mount (0-100) by ID, or `nil`.
---@param mountID number The mount ID.
function MountsRarity:GetRarityByID(mountID)
  return self:GetData()[mountID]
end

-- Everything after this line gets automatically replaced and updated.
lazyLoadData = function() return {
  [6] = 63.1148,
  [8] = 0.0001,
  [9] = 66.3026,
  [11] = 64.9113,
  [14] = 64.9062,
  [17] = 89.6653,
  [18] = 70.2165,
  [19] = 70.2131,
  [20] = 63.1109,
  [21] = 62.2489,
  [24] = 56.5568,
  [25] = 55.5432,
  [26] = 64.8981,
  [27] = 62.2507,
  [31] = 60.7618,
  [34] = 67.8246,
  [36] = 56.5571,
  [38] = 55.546,
  [39] = 54.5517,
  [40] = 54.1592,
  [41] = 52.4469,
  [42] = 0.0081,
  [43] = 0.0001,
  [45] = 0.0273,
  [46] = 0.009,
  [50] = 0.0163,
  [51] = 0.0274,
  [52] = 0.0163,
  [53] = 0.0156,
  [54] = 0.0048,
  [55] = 14.5942,
  [56] = 0.0093,
  [57] = 57.5081,
  [58] = 57.2311,
  [62] = 0.0054,
  [63] = 0.0093,
  [64] = 0.0048,
  [65] = 64.071,
  [66] = 67.8183,
  [67] = 60.7559,
  [68] = 59.9913,
  [69] = 18.7075,
  [71] = 57.5105,
  [72] = 54.1588,
  [73] = 0.0054,
  [74] = 0.0082,
  [75] = 44.9898,
  [76] = 44.3709,
  [77] = 44.3724,
  [78] = 45.6901,
  [79] = 45.6901,
  [80] = 48.8537,
  [81] = 48.8569,
  [82] = 44.9891,
  [83] = 89.097,
  [84] = 52.1005,
  [85] = 60.8748,
  [87] = 60.7595,
  [88] = 52.102,
  [89] = 50.3938,
  [90] = 49.9616,
  [91] = 64.1198,
  [92] = 64.5632,
  [93] = 61.4915,
  [94] = 53.3462,
  [95] = 52.0765,
  [96] = 52.1326,
  [97] = 52.0766,
  [98] = 52.1326,
  [99] = 53.3485,
  [100] = 60.8738,
  [101] = 52.1039,
  [102] = 50.3931,
  [103] = 49.9622,
  [104] = 61.4892,
  [105] = 64.1175,
  [106] = 64.5586,
  [107] = 59.9955,
  [108] = 17.8437,
  [109] = 16.5949,
  [110] = 2.0641,
  [111] = 2.0148,
  [117] = 61.4982,
  [118] = 39.7904,
  [119] = 61.6473,
  [120] = 61.474,
  [122] = 0.0257,
  [125] = 19.2689,
  [129] = 46.4922,
  [130] = 46.4644,
  [131] = 47.3916,
  [132] = 41.7142,
  [133] = 48.4277,
  [134] = 48.6886,
  [135] = 46.7741,
  [136] = 44.5856,
  [137] = 43.0191,
  [138] = 40.5622,
  [139] = 55.9862,
  [140] = 41.623,
  [141] = 42.3641,
  [142] = 58.7811,
  [146] = 53.3349,
  [147] = 62.1786,
  [149] = 53.5647,
  [150] = 53.8862,
  [151] = 23.847,
  [152] = 64.8136,
  [153] = 25.4894,
  [154] = 25.5509,
  [155] = 25.3165,
  [156] = 24.9825,
  [157] = 57.2341,
  [158] = 57.7535,
  [159] = 62.1244,
  [160] = 54.337,
  [161] = 53.191,
  [162] = 42.1425,
  [163] = 57.7509,
  [164] = 64.8131,
  [165] = 53.1888,
  [166] = 54.336,
  [167] = 53.3341,
  [168] = 17.1595,
  [169] = 0.0598,
  [170] = 24.8908,
  [171] = 19.9947,
  [172] = 24.85,
  [173] = 24.7721,
  [174] = 24.9061,
  [176] = 22.6358,
  [177] = 23.3319,
  [178] = 23.0104,
  [179] = 23.1572,
  [180] = 22.8497,
  [183] = 27.3586,
  [185] = 25.7654,
  [186] = 28.6289,
  [187] = 26.5748,
  [188] = 26.2658,
  [189] = 26.0729,
  [190] = 26.6327,
  [191] = 26.5277,
  [196] = 1.0231,
  [197] = 1.1036,
  [199] = 1.7645,
  [201] = 0.8896,
  [202] = 34.2777,
  [203] = 26.6395,
  [204] = 20.0503,
  [205] = 35.4936,
  [207] = 0.0952,
  [211] = 0.2497,
  [212] = 1.1782,
  [213] = 45.2989,
  [219] = 33.7826,
  [220] = 42.1435,
  [221] = 89.3495,
  [222] = 0.0001,
  [223] = 0.1261,
  [224] = 39.7619,
  [226] = 34.1604,
  [230] = 20.6407,
  [236] = 50.7729,
  [237] = 13.6639,
  [240] = 23.6514,
  [241] = 0.1054,
  [243] = 0.7262,
  [246] = 23.2516,
  [247] = 33.8681,
  [248] = 67.1203,
  [249] = 30.8815,
  [250] = 65.5163,
  [253] = 60.8,
  [254] = 26.1269,
  [255] = 26.9213,
  [256] = 28.092,
  [257] = 29.3483,
  [258] = 15.5667,
  [259] = 15.5524,
  [262] = 29.9788,
  [263] = 0.3985,
  [264] = 18.7705,
  [265] = 8.2124,
  [266] = 0.9427,
  [267] = 17.0457,
  [268] = 88.9675,
  [269] = 40.3152,
  [270] = 42.2407,
  [271] = 22.9774,
  [272] = 23.9978,
  [275] = 23.6872,
  [276] = 31.546,
  [277] = 32.2018,
  [278] = 18.2382,
  [279] = 23.3508,
  [280] = 43.9569,
  [284] = 47.1654,
  [285] = 39.2489,
  [286] = 19.3368,
  [287] = 19.7849,
  [288] = 11.5716,
  [289] = 11.4545,
  [291] = 43.0142,
  [292] = 44.7259,
  [293] = 46.6647,
  [294] = 7.4449,
  [295] = 7.0774,
  [296] = 7.0772,
  [297] = 8.8325,
  [298] = 6.8221,
  [299] = 7.1188,
  [300] = 7.4449,
  [301] = 6.822,
  [302] = 7.1189,
  [303] = 8.8323,
  [304] = 10.4535,
  [305] = 10.4346,
  [306] = 44.7674,
  [307] = 44.8231,
  [309] = 54.5534,
  [310] = 66.3008,
  [311] = 12.9585,
  [312] = 15.2841,
  [313] = 0.0687,
  [314] = 64.8931,
  [317] = 0.0717,
  [318] = 19.3883,
  [319] = 20.834,
  [320] = 19.3883,
  [321] = 19.8698,
  [322] = 11.0994,
  [323] = 17.7619,
  [324] = 18.0291,
  [325] = 18.0286,
  [326] = 20.8332,
  [327] = 19.8687,
  [328] = 0.9315,
  [329] = 7.3237,
  [330] = 7.3987,
  [331] = 5.9766,
  [332] = 5.4431,
  [336] = 60.7543,
  [337] = 64.0714,
  [338] = 4.0672,
  [340] = 0.0375,
  [341] = 9.679,
  [342] = 0.8998,
  [343] = 0.7562,
  [344] = 0.0459,
  [345] = 0.0605,
  [349] = 22.9835,
  [350] = 21.8483,
  [351] = 21.3051,
  [352] = 8.1808,
  [358] = 0.0572,
  [363] = 17.1851,
  [364] = 42.6104,
  [365] = 31.9978,
  [366] = 17.0099,
  [367] = 32.1428,
  [368] = 30.4816,
  [371] = 37.8348,
  [372] = 1.0926,
  [373] = 45.9957,
  [375] = 15.3742,
  [376] = 52.363,
  [382] = 47.2095,
  [386] = 21.924,
  [388] = 55.3803,
  [389] = 49.0304,
  [391] = 19.42,
  [392] = 23.3688,
  [393] = 8.7765,
  [394] = 18.7466,
  [395] = 22.3367,
  [396] = 10.9384,
  [397] = 20.384,
  [398] = 35.5221,
  [399] = 35.3465,
  [400] = 4.4085,
  [401] = 58.7034,
  [403] = 41.7646,
  [404] = 5.4518,
  [405] = 9.0377,
  [406] = 9.0627,
  [407] = 47.8891,
  [408] = 0.5304,
  [409] = 44.2637,
  [410] = 10.7717,
  [411] = 13.5748,
  [412] = 0.5271,
  [413] = 19.959,
  [415] = 22.8022,
  [416] = 35.0037,
  [417] = 38.0799,
  [418] = 0.5156,
  [419] = 48.5197,
  [420] = 38.7056,
  [421] = 17.4132,
  [422] = 5.5203,
  [423] = 5.7029,
  [424] = 0.0427,
  [425] = 24.8847,
  [426] = 18.5199,
  [428] = 0.0323,
  [429] = 14.1204,
  [430] = 30.6298,
  [431] = 23.279,
  [432] = 21.5396,
  [433] = 0.4753,
  [434] = 19.5685,
  [435] = 55.3726,
  [436] = 49.023,
  [439] = 44.5672,
  [440] = 19.6069,
  [441] = 19.2749,
  [442] = 10.0508,
  [443] = 23.7326,
  [444] = 11.2715,
  [445] = 9.1403,
  [446] = 18.9226,
  [447] = 34.9164,
  [448] = 42.5769,
  [449] = 34.6482,
  [450] = 10.2721,
  [451] = 15.1039,
  [452] = 47.5836,
  [453] = 44.605,
  [454] = 52.7976,
  [455] = 14.2997,
  [456] = 21.4153,
  [457] = 19.3953,
  [458] = 21.5424,
  [459] = 19.1175,
  [460] = 53.5561,
  [462] = 22.5369,
  [463] = 21.3747,
  [464] = 44.0569,
  [465] = 42.9676,
  [466] = 42.9657,
  [467] = 0.0298,
  [468] = 17.8389,
  [469] = 11.9045,
  [470] = 11.2713,
  [471] = 31.0916,
  [472] = 9.9809,
  [473] = 32.6475,
  [474] = 9.2842,
  [475] = 15.6736,
  [476] = 24.1881,
  [477] = 27.2483,
  [478] = 33.9387,
  [479] = 29.7725,
  [480] = 27.2873,
  [481] = 27.2694,
  [482] = 22.526,
  [484] = 22.8304,
  [485] = 22.0371,
  [486] = 39.9905,
  [487] = 40.111,
  [488] = 4.4006,
  [492] = 49.9452,
  [493] = 48.039,
  [494] = 47.2268,
  [495] = 48.5017,
  [496] = 52.3174,
  [497] = 43.0291,
  [498] = 44.3663,
  [499] = 43.4557,
  [500] = 42.6598,
  [501] = 43.2981,
  [503] = 7.1955,
  [504] = 19.4322,
  [505] = 27.6434,
  [506] = 31.0952,
  [507] = 27.9204,
  [508] = 24.9368,
  [509] = 35.1053,
  [510] = 21.6467,
  [511] = 22.9072,
  [515] = 18.4057,
  [516] = 10.4913,
  [517] = 37.7557,
  [518] = 7.1914,
  [519] = 7.1878,
  [520] = 7.1895,
  [521] = 57.8802,
  [522] = 53.0264,
  [523] = 36.7053,
  [526] = 11.1097,
  [527] = 10.6876,
  [528] = 16.8881,
  [529] = 16.2479,
  [530] = 8.7933,
  [531] = 23.799,
  [532] = 27.6238,
  [533] = 17.1697,
  [534] = 22.8589,
  [535] = 25.3014,
  [536] = 23.4882,
  [537] = 20.9491,
  [538] = 31.7904,
  [539] = 31.9329,
  [540] = 31.7615,
  [541] = 0.0216,
  [542] = 20.5342,
  [543] = 25.664,
  [544] = 32.1291,
  [545] = 11.183,
  [546] = 11.258,
  [547] = 63.5624,
  [548] = 28.0685,
  [549] = 27.6275,
  [550] = 9.4231,
  [551] = 15.6287,
  [552] = 28.4058,
  [554] = 6.602,
  [555] = 7.0431,
  [557] = 10.613,
  [558] = 14.0861,
  [559] = 23.5584,
  [560] = 4.9194,
  [561] = 28.2003,
  [562] = 0.0242,
  [563] = 0.0465,
  [564] = 0.0694,
  [568] = 5.6351,
  [571] = 11.5033,
  [593] = 32.0342,
  [594] = 9.8985,
  [600] = 24.0065,
  [603] = 15.5952,
  [606] = 50.5219,
  [607] = 5.0034,
  [608] = 22.9253,
  [609] = 24.3676,
  [611] = 13.7157,
  [612] = 17.1191,
  [613] = 8.1787,
  [614] = 25.3499,
  [615] = 24.5214,
  [616] = 4.5908,
  [617] = 9.3111,
  [618] = 7.2639,
  [619] = 19.3312,
  [620] = 25.0154,
  [621] = 16.9169,
  [622] = 13.7309,
  [623] = 7.6656,
  [624] = 17.791,
  [625] = 13.7518,
  [626] = 4.5991,
  [627] = 21.7787,
  [628] = 24.5095,
  [629] = 24.2015,
  [630] = 16.6084,
  [631] = 35.3977,
  [632] = 7.9139,
  [633] = 8.4738,
  [634] = 2.8614,
  [635] = 14.496,
  [636] = 25.7601,
  [637] = 24.2607,
  [638] = 4.8081,
  [639] = 5.0925,
  [640] = 4.3009,
  [641] = 4.9838,
  [642] = 4.5967,
  [643] = 13.7268,
  [644] = 11.9218,
  [645] = 7.3798,
  [646] = 40.525,
  [647] = 24.3522,
  [648] = 9.6138,
  [649] = 4.6177,
  [650] = 11.8758,
  [651] = 48.7994,
  [652] = 9.3195,
  [654] = 5.2686,
  [655] = 16.9255,
  [656] = 28.7022,
  [657] = 59.886,
  [663] = 1.755,
  [664] = 5.6281,
  [678] = 41.7849,
  [679] = 39.8737,
  [682] = 5.286,
  [741] = 13.7316,
  [751] = 8.9469,
  [753] = 23.1778,
  [755] = 3.8289,
  [756] = 4.087,
  [758] = 10.243,
  [759] = 0.0507,
  [760] = 0.0255,
  [761] = 0.0458,
  [762] = 66.3453,
  [763] = 25.3612,
  [764] = 23.9929,
  [765] = 9.2022,
  [768] = 18.3425,
  [769] = 13.2267,
  [772] = 36.6528,
  [773] = 8.0691,
  [775] = 5.1402,
  [778] = 18.6581,
  [779] = 26.1376,
  [780] = 87.6355,
  [781] = 31.0153,
  [784] = 5.2895,
  [791] = 5.3626,
  [793] = 6.3087,
  [794] = 5.9417,
  [795] = 6.6592,
  [796] = 6.0841,
  [797] = 29.4527,
  [800] = 9.5082,
  [802] = 9.9622,
  [803] = 6.3915,
  [804] = 7.9368,
  [826] = 49.2303,
  [831] = 6.5613,
  [832] = 8.1982,
  [833] = 25.9442,
  [834] = 15.3279,
  [836] = 3.409,
  [838] = 15.2463,
  [841] = 4.0207,
  [842] = 4.2165,
  [843] = 3.6101,
  [844] = 3.4021,
  [845] = 21.1481,
  [846] = 9.3603,
  [847] = 13.0033,
  [848] = 0.0458,
  [849] = 0.0335,
  [850] = 0.0242,
  [851] = 0.0296,
  [852] = 0.0312,
  [853] = 0.0375,
  [854] = 7.3132,
  [855] = 18.4342,
  [860] = 14.1236,
  [861] = 12.2404,
  [864] = 13.8427,
  [865] = 17.4231,
  [866] = 16.1916,
  [867] = 14.9193,
  [868] = 16.4009,
  [870] = 10.9813,
  [872] = 11.4589,
  [873] = 4.1411,
  [874] = 4.2498,
  [875] = 9.9816,
  [876] = 3.7739,
  [877] = 1.0627,
  [878] = 9.6963,
  [881] = 38.2082,
  [882] = 3.6236,
  [883] = 33.0618,
  [884] = 12.7827,
  [885] = 18.9209,
  [888] = 15.1246,
  [889] = 8.2632,
  [890] = 8.3504,
  [891] = 8.1875,
  [892] = 14.3802,
  [893] = 13.7774,
  [894] = 13.5332,
  [896] = 18.0308,
  [898] = 14.5952,
  [899] = 12.8629,
  [900] = 3.7673,
  [901] = 3.6853,
  [905] = 11.0248,
  [906] = 28.1167,
  [926] = 15.0056,
  [928] = 9.9792,
  [930] = 11.1253,
  [931] = 9.6615,
  [932] = 7.7699,
  [933] = 3.9202,
  [937] = 0.0331,
  [939] = 22.0667,
  [941] = 9.7794,
  [942] = 10.0363,
  [943] = 9.1204,
  [944] = 12.0782,
  [945] = 4.8303,
  [946] = 4.8937,
  [947] = 22.1867,
  [948] = 0.0395,
  [949] = 11.6672,
  [954] = 5.2547,
  [955] = 15.4685,
  [956] = 17.2985,
  [958] = 6.0407,
  [959] = 6.2021,
  [960] = 6.0038,
  [961] = 19.2327,
  [962] = 7.015,
  [963] = 8.2797,
  [964] = 22.0218,
  [965] = 22.4795,
  [966] = 21.307,
  [967] = 21.4646,
  [968] = 21.3002,
  [970] = 14.5498,
  [971] = 15.7053,
  [972] = 11.3638,
  [973] = 11.4156,
  [974] = 28.1459,
  [975] = 28.1374,
  [976] = 28.1332,
  [978] = 25.5261,
  [979] = 17.2258,
  [980] = 11.3878,
  [981] = 18.246,
  [982] = 1.9231,
  [983] = 11.1862,
  [984] = 11.3425,
  [985] = 11.3121,
  [986] = 34.617,
  [993] = 7.4199,
  [994] = 16.3016,
  [995] = 15.7275,
  [996] = 18.1654,
  [997] = 18.4855,
  [999] = 32.302,
  [1006] = 41.0306,
  [1007] = 40.2995,
  [1008] = 39.1454,
  [1009] = 43.6021,
  [1010] = 12.2289,
  [1011] = 10.0568,
  [1012] = 2.6186,
  [1013] = 9.9748,
  [1015] = 9.6418,
  [1016] = 9.6877,
  [1018] = 4.6041,
  [1019] = 6.2556,
  [1025] = 10.9481,
  [1026] = 3.281,
  [1027] = 3.3135,
  [1028] = 11.3287,
  [1030] = 0.2606,
  [1031] = 0.0931,
  [1032] = 0.0892,
  [1035] = 0.3742,
  [1038] = 41.2261,
  [1039] = 3.9191,
  [1040] = 9.2921,
  [1042] = 9.6086,
  [1043] = 4.7414,
  [1044] = 39.9704,
  [1045] = 5.0047,
  [1046] = 13.3367,
  [1047] = 14.5189,
  [1048] = 39.0536,
  [1049] = 27.6199,
  [1050] = 4.978,
  [1051] = 42.4804,
  [1053] = 13.0851,
  [1054] = 26.6457,
  [1057] = 5.5643,
  [1058] = 17.1489,
  [1059] = 3.8072,
  [1060] = 4.0683,
  [1061] = 12.7162,
  [1062] = 3.7143,
  [1063] = 3.717,
  [1064] = 4.3167,
  [1166] = 12.9635,
  [1167] = 21.3068,
  [1168] = 30.6434,
  [1169] = 12.0812,
  [1172] = 2.6296,
  [1173] = 14.0391,
  [1174] = 14.0712,
  [1175] = 8.2613,
  [1176] = 10.4816,
  [1178] = 8.5535,
  [1179] = 1.3581,
  [1180] = 18.8106,
  [1182] = 17.4537,
  [1183] = 17.3827,
  [1185] = 17.7545,
  [1190] = 8.5361,
  [1191] = 16.7365,
  [1192] = 0.9529,
  [1193] = 11.8353,
  [1194] = 6.4451,
  [1195] = 4.0545,
  [1196] = 4.2366,
  [1197] = 6.9345,
  [1198] = 32.7306,
  [1199] = 17.1073,
  [1200] = 16.0308,
  [1201] = 3.7091,
  [1203] = 16.0914,
  [1204] = 11.8304,
  [1205] = 17.2878,
  [1206] = 2.0479,
  [1207] = 1.5946,
  [1208] = 8.1612,
  [1209] = 12.7813,
  [1210] = 6.5723,
  [1211] = 13.1036,
  [1212] = 7.5782,
  [1213] = 5.1819,
  [1214] = 12.398,
  [1215] = 12.5852,
  [1216] = 8.0412,
  [1217] = 5.2504,
  [1218] = 6.8661,
  [1219] = 15.0911,
  [1220] = 11.4657,
  [1221] = 8.2243,
  [1222] = 12.8273,
  [1223] = 17.3791,
  [1224] = 53.0844,
  [1225] = 18.1846,
  [1227] = 13.4669,
  [1229] = 3.9472,
  [1230] = 11.5939,
  [1231] = 10.5094,
  [1232] = 5.5283,
  [1237] = 8.8154,
  [1238] = 5.552,
  [1239] = 41.4742,
  [1240] = 51.8258,
  [1242] = 10.1667,
  [1243] = 14.2526,
  [1245] = 23.2115,
  [1246] = 23.2115,
  [1247] = 4.5832,
  [1248] = 5.6311,
  [1249] = 7.9608,
  [1250] = 6.3742,
  [1252] = 6.8525,
  [1253] = 33.0907,
  [1254] = 2.29,
  [1255] = 16.5408,
  [1256] = 16.5408,
  [1257] = 1.9864,
  [1258] = 5.5234,
  [1259] = 21.3707,
  [1260] = 12.7101,
  [1262] = 4.0927,
  [1265] = 34.5324,
  [1266] = 13.5331,
  [1267] = 13.4247,
  [1277] = 1.6011,
  [1282] = 23.1704,
  [1283] = 28.8435,
  [1285] = 12.1236,
  [1286] = 41.0048,
  [1287] = 6.749,
  [1288] = 10.6802,
  [1289] = 65.2937,
  [1290] = 19.2121,
  [1291] = 24.8457,
  [1292] = 11.4317,
  [1293] = 3.5795,
  [1297] = 5.6808,
  [1298] = 2.6641,
  [1299] = 46.1044,
  [1302] = 69.8691,
  [1303] = 53.9403,
  [1304] = 2.9853,
  [1305] = 19.5529,
  [1306] = 13.3819,
  [1307] = 10.9381,
  [1309] = 18.7712,
  [1310] = 13.4652,
  [1311] = 13.4897,
  [1312] = 9.2807,
  [1313] = 5.2871,
  [1314] = 5.1534,
  [1315] = 19.5166,
  [1317] = 3.7291,
  [1318] = 12.0078,
  [1319] = 6.3726,
  [1320] = 11.6423,
  [1321] = 5.5723,
  [1322] = 5.5607,
  [1324] = 9.5496,
  [1326] = 16.3458,
  [1327] = 3.7793,
  [1328] = 4.6738,
  [1329] = 10.0346,
  [1330] = 13.7523,
  [1332] = 8.1322,
  [1346] = 19.0569,
  [1350] = 18.8165,
  [1351] = 7.5622,
  [1352] = 8.2326,
  [1354] = 16.2773,
  [1355] = 6.8901,
  [1356] = 5.5742,
  [1357] = 61.9675,
  [1358] = 4.0112,
  [1359] = 6.3049,
  [1360] = 35.7795,
  [1361] = 19.887,
  [1362] = 29.8833,
  [1363] = 0.4061,
  [1364] = 53.4502,
  [1365] = 13.3675,
  [1366] = 2.0567,
  [1367] = 4.5664,
  [1368] = 43.3819,
  [1369] = 54.8072,
  [1370] = 7.6684,
  [1371] = 4.0022,
  [1372] = 4.1802,
  [1373] = 4.4488,
  [1375] = 14.5046,
  [1376] = 7.5815,
  [1377] = 9.3195,
  [1378] = 13.6935,
  [1379] = 3.4781,
  [1382] = 1.7951,
  [1384] = 15.3203,
  [1385] = 51.0927,
  [1387] = 1.5527,
  [1388] = 57.4765,
  [1389] = 2.8649,
  [1391] = 6.9518,
  [1392] = 7.0952,
  [1393] = 15.0987,
  [1394] = 6.0991,
  [1395] = 9.156,
  [1396] = 55.318,
  [1397] = 32.3626,
  [1398] = 14.6419,
  [1399] = 58.4566,
  [1400] = 51.6248,
  [1401] = 2.4701,
  [1402] = 2.3135,
  [1404] = 11.655,
  [1405] = 19.6785,
  [1406] = 14.6828,
  [1407] = 10.8197,
  [1408] = 8.3016,
  [1409] = 4.3893,
  [1410] = 4.9241,
  [1411] = 9.7677,
  [1413] = 8.6576,
  [1414] = 18.8735,
  [1415] = 44.5756,
  [1416] = 18.3483,
  [1417] = 6.702,
  [1419] = 21.3356,
  [1420] = 5.9819,
  [1421] = 18.0041,
  [1422] = 17.3293,
  [1423] = 18.3678,
  [1424] = 8.9104,
  [1425] = 15.9424,
  [1426] = 3.2225,
  [1428] = 22.3343,
  [1429] = 6.5235,
  [1430] = 5.4907,
  [1431] = 5.6496,
  [1433] = 3.3338,
  [1434] = 9.1447,
  [1436] = 4.4535,
  [1437] = 25.7887,
  [1438] = 11.2229,
  [1439] = 11.2452,
  [1440] = 11.2409,
  [1441] = 2.8996,
  [1442] = 20.0467,
  [1443] = 4.2113,
  [1444] = 13.5413,
  [1445] = 19.1416,
  [1446] = 21.827,
  [1448] = 5.1359,
  [1449] = 9.6826,
  [1450] = 14.108,
  [1451] = 3.8193,
  [1452] = 3.8383,
  [1454] = 8.3859,
  [1455] = 10.8821,
  [1456] = 23.4295,
  [1458] = 84.9825,
  [1459] = 5.6567,
  [1460] = 5.4339,
  [1465] = 3.2599,
  [1466] = 3.1557,
  [1467] = 9.5354,
  [1468] = 24.1213,
  [1469] = 21.4401,
  [1471] = 3.2668,
  [1474] = 5.3484,
  [1475] = 11.6003,
  [1476] = 13.1123,
  [1477] = 13.8004,
  [1478] = 6.3374,
  [1480] = 0.5488,
  [1481] = 16.1919,
  [1484] = 59.3406,
  [1485] = 16.3894,
  [1486] = 5.0308,
  [1487] = 12.7856,
  [1489] = 16.0287,
  [1490] = 54.9246,
  [1491] = 4.6192,
  [1492] = 56.047,
  [1493] = 12.8724,
  [1494] = 13.3251,
  [1495] = 52.6612,
  [1496] = 13.1423,
  [1497] = 4.3656,
  [1500] = 7.1285,
  [1501] = 9.0365,
  [1502] = 10.3697,
  [1503] = 9.2657,
  [1504] = 4.2638,
  [1505] = 16.4743,
  [1506] = 11.8956,
  [1507] = 8.252,
  [1508] = 10.9191,
  [1509] = 6.0341,
  [1510] = 16.2915,
  [1511] = 12.951,
  [1513] = 28.3518,
  [1514] = 19.3949,
  [1517] = 5.0194,
  [1520] = 20.6585,
  [1521] = 15.8678,
  [1522] = 15.4148,
  [1523] = 2.9608,
  [1524] = 2.7245,
  [1525] = 5.0996,
  [1526] = 25.9269,
  [1528] = 4.2384,
  [1529] = 29.1897,
  [1531] = 23.7469,
  [1532] = 2.6488,
  [1533] = 6.1755,
  [1534] = 4.6272,
  [1535] = 2.8228,
  [1536] = 2.3082,
  [1537] = 6.5364,
  [1538] = 3.9845,
  [1539] = 2.306,
  [1540] = 4.7378,
  [1541] = 5.4543,
  [1542] = 6.8867,
  [1543] = 4.1789,
  [1544] = 21.6802,
  [1545] = 8.2456,
  [1546] = 4.2178,
  [1547] = 3.1306,
  [1549] = 5.4331,
  [1550] = 53.9578,
  [1551] = 7.6887,
  [1552] = 17.0587,
  [1553] = 1.2034,
  [1556] = 54.5858,
  [1563] = 95.9528,
  [1564] = 11.5758,
  [1565] = 13.5449,
  [1566] = 25.3154,
  [1568] = 20.1186,
  [1569] = 20.9635,
  [1570] = 3.2491,
  [1571] = 2.5246,
  [1572] = 0.2277,
  [1573] = 32.6905,
  [1574] = 32.0431,
  [1575] = 40.0893,
  [1576] = 28.4031,
  [1577] = 49.9057,
  [1579] = 0.186,
  [1580] = 6.6452,
  [1581] = 26.2946,
  [1582] = 39.9512,
  [1583] = 3.2748,
  [1584] = 6.3557,
  [1585] = 9.6446,
  [1586] = 19.3549,
  [1587] = 1.9331,
  [1588] = 81.6547,
  [1589] = 97.4393,
  [1590] = 94.6377,
  [1591] = 92.0597,
  [1594] = 27.4123,
  [1596] = 43.0862,
  [1597] = 9.5733,
  [1599] = 0.0697,
  [1600] = 9.5384,
  [1602] = 6.8917,
  [1603] = 16.325,
  [1612] = 16.7375,
  [1614] = 4.7629,
  [1615] = 22.478,
  [1616] = 19.9788,
  [1617] = 13.763,
  [1618] = 6.1832,
  [1619] = 22.2276,
  [1621] = 5.8701,
  [1622] = 42.9919,
  [1623] = 6.9457,
  [1626] = 3.5187,
  [1627] = 3.4045,
  [1629] = 7.006,
  [1633] = 5.9125,
  [1634] = 11.0485,
  [1635] = 30.7485,
  [1638] = 7.6476,
  [1639] = 18.2005,
  [1644] = 7.5827,
  [1645] = 11.1868,
  [1651] = 5.1831,
  [1653] = 16.0762,
  [1654] = 10.1986,
  [1655] = 17.1598,
  [1656] = 6.2006,
  [1657] = 20.8185,
  [1658] = 10.7852,
  [1659] = 21.1248,
  [1660] = 0.1618,
  [1662] = 9.2807,
  [1664] = 32.0979,
  [1665] = 31.3927,
  [1667] = 31.9941,
  [1668] = 31.7385,
  [1669] = 6.5975,
  [1671] = 18.1933,
  [1672] = 13.8842,
  [1674] = 19.2175,
  [1679] = 37.3185,
  [1681] = 33.0269,
  [1683] = 38.6303,
  [1684] = 45.7504,
  [1685] = 36.6642,
  [1686] = 50.2601,
  [1688] = 4.0677,
  [1689] = 3.9769,
  [1692] = 27.4113,
  [1698] = 3.2973,
  [1699] = 14.58,
  [1725] = 30.9558,
  [1727] = 4.4528,
  [1729] = 4.9405,
  [1730] = 7.7116,
  [1732] = 1.5717,
  [1733] = 7.7845,
  [1734] = 6.5983,
  [1735] = 23.2605,
  [1736] = 10.1378,
  [1737] = 18.675,
  [1738] = 17.8279,
  [1739] = 0.1914,
  [1740] = 2.9444,
  [1741] = 2.7695,
  [1742] = 22.0068,
  [1744] = 49.684,
  [1772] = 40.8313,
  [1773] = 42.9573,
  [1774] = 3.6269,
  [1776] = 26.6251,
  [1777] = 27.9094,
  [1778] = 18.449,
  [1779] = 22.2169,
  [1781] = 18.5221,
  [1782] = 18.2908,
  [1783] = 23.3032,
  [1784] = 30.0438,
  [1785] = 15.3184,
  [1792] = 49.6176,
  [1794] = 10.621,
  [1795] = 26.0659,
  [1797] = 14.58,
  [1798] = 46.6034,
  [1799] = 33.7702,
  [1801] = 35.5288,
  [1808] = 30.6853,
  [1809] = 28.8225,
  [1810] = 30.9791,
  [1811] = 29.1088,
  [1812] = 7.9616,
  [1813] = 8.8251,
  [1814] = 7.0742,
  [1815] = 39.5816,
  [1816] = 31.6197,
  [1817] = 31.3181,
  [1818] = 3.0753,
  [1819] = 2.5433,
  [1820] = 2.3585,
  [1822] = 0.2189,
  [1824] = 12.4333,
  [1825] = 4.387,
  [1830] = 71.6425,
  [1831] = 0.1568,
  [1833] = 31.4085,
  [1834] = 7.2072,
  [1835] = 31.6448,
  [1837] = 21.6606,
  [1838] = 28.848,
  [1839] = 29.6939,
  [1841] = 38.6767,
  [1938] = 20.8726,
  [1939] = 21.678,
  [1940] = 28.33,
  [1941] = 9.9482,
  [1942] = 29.0426,
  [1943] = 8.2474,
  [1944] = 1.5111,
  [1947] = 9.7806,
  [1948] = 2.9388,
  [1949] = 33.9232,
  [1956] = 33.5252,
  [1957] = 1.8342,
  [1958] = 29.6155,
  [1959] = 17.2893,
  [2023] = 6.5006,
  [2035] = 29.1276,
  [2036] = 23.1114,
  [2038] = 9.3935,
  [2039] = 19.6029,
  [2055] = 25.6945,
  [2056] = 1.7968,
  [2057] = 1.6042,
  [2060] = 26.5546,
  [2063] = 24.8712,
  [2064] = 26.163,
  [2065] = 19.8289,
  [2067] = 19.9638,
  [2068] = 20.6946,
  [2069] = 26.5391,
  [2070] = 20.3565,
  [2071] = 21.534,
  [2072] = 23.0291,
  [2073] = 22.7936,
  [2074] = 22.9506,
  [2075] = 22.6142,
  [2076] = 22.6175,
  [2077] = 22.4545,
  [2078] = 23.7349,
  [2080] = 23.8411,
  [2081] = 21.9932,
  [2083] = 22.5445,
  [2084] = 20.9028,
  [2085] = 23.483,
  [2086] = 22.6908,
  [2087] = 25.3083,
  [2088] = 23.3243,
  [2089] = 22.7558,
  [2090] = 15.8594,
  [2091] = 21.7114,
  [2114] = 2.8021,
  [2116] = 14.5,
  [2117] = 13.7299,
  [2118] = 20.4404,
  [2119] = 2.1619,
  [2140] = 27.2357,
  [2142] = 44.5455,
  [2143] = 21.3473,
  [2144] = 63.9015,
  [2148] = 15.1491,
  [2150] = 2.1872,
  [2152] = 30.3483,
  [2158] = 0.2438,
  [2159] = 23.424,
  [2162] = 14.0532,
  [2165] = 11.1229,
  [2167] = 1.3441,
  [2171] = 21.2994,
  [2172] = 18.4931,
  [2174] = 17.3203,
  [2176] = 4.1016,
  [2177] = 18.4935,
  [2178] = 2.0651,
  [2180] = 6.7329,
  [2181] = 30.5333,
  [2184] = 19.4326,
  [2188] = 4.2042,
  [2189] = 27.678,
  [2190] = 3.6361,
  [2191] = 15.7311,
  [2192] = 9.118,
  [2193] = 16.9848,
  [2194] = 16.8125,
  [2198] = 29.1785,
  [2199] = 26.8345,
  [2201] = 29.7735,
  [2203] = 26.8345,
  [2204] = 16.0838,
  [2205] = 2.4203,
  [2209] = 16.4584,
  [2211] = 2.4183,
  [2213] = 17.7721,
  [2214] = 42.1981,
  [2218] = 0.1201,
  [2219] = 5.212,
  [2222] = 5.5693,
  [2223] = 1.6134,
  [2224] = 23.0352,
  [2225] = 10.9154,
  [2230] = 7.8195,
  [2232] = 0.4956,
  [2233] = 8.1046,
  [2235] = 14.238,
  [2237] = 6.9253,
  [2238] = 57.8948,
  [2239] = 26.2879,
  [2240] = 8.9488,
  [2244] = 36.5493,
  [2249] = 37.6473,
  [2259] = 14.238,
  [2261] = 24.8728,
  [2265] = 20.1084,
  [2272] = 1.1168,
  [2274] = 0.1055,
  [2276] = 0.9856,
  [2277] = 9.8328,
  [2278] = 0.1925,
  [2279] = 9.6602,
  [2280] = 7.3209,
  [2281] = 0.1179,
  [2283] = 0.0844,
  [2284] = 0.475,
  [2286] = 0.8373,
  [2287] = 1.136,
  [2288] = 3.6831,
  [2289] = 0.0898,
  [2290] = 0.0735,
  [2291] = 7.6545,
  [2292] = 0.0654,
  [2293] = 2.1166,
  [2294] = 0.9223,
  [2295] = 0.1442,
  [2296] = 37.7773,
  [2298] = 0.0213,
  [2299] = 0.6083,
  [2300] = 0.7413,
  [2303] = 5.6341,
  [2304] = 3.872,
  [2305] = 3.872,
  [2307] = 3.872,
  [2308] = 3.872,
  [2313] = 3.9699,
  [2315] = 20.4925,
  [2317] = 10.1583,
  [2321] = 16.2642,
  [2322] = 7.3962,
  [2324] = 10.594,
  [2327] = 8.365,
  [2328] = 11.5696,
  [2329] = 27.0433,
  [2330] = 2.4934,
  [2331] = 2.4934,
  [2332] = 7.6488,
  [2333] = 8.5298,
  [2334] = 0.179,
  [2339] = 1.3891,
  [2342] = 1.1759,
  [2343] = 1.1759,
  [2344] = 1.1759,
  [2345] = 1.4087,
  [2346] = 1.1759,
  [2347] = 13.3829,
  [2469] = 11.1086,
  [2470] = 7.6078,
  [2471] = 9.6978,
  [2473] = 8.4207,
  [2474] = 7.6539,
  [2476] = 2.8717,
  [2477] = 2.8717,
  [2480] = 29.1745,
  [2482] = 10.4867,
  [2483] = 16.8706,
  [2487] = 0.6528,
  [2488] = 18.3882,
  [2489] = 19.4818,
  [2491] = 15.8567,
  [2495] = 16.1257,
  [2496] = 2.9357,
  [2497] = 4.0882,
  [2498] = 3.4313,
  [2499] = 3.0666,
  [2500] = 0.7768,
  [2501] = 1.3727,
  [2502] = 1.4044,
  [2504] = 3.3858,
  [2507] = 3.1119,
  [2508] = 11.4231,
  [2518] = 1.3337,
  [2519] = 2.7902,
  [2520] = 14.0443,
  [2524] = 7.2163,
  [2525] = 1.4269,
  [2526] = 0.7683,
  [2527] = 7.4277,
  [2529] = 1.4269,
  [2531] = 0.5022,
  [2535] = 3.6354,
  [2579] = 0.0131,
  [2580] = 0.0909,
  [2582] = 0.0034,
  [2586] = 1.2489,
  [2587] = 1.0768,
  [2600] = 0.0601,
  [2604] = 0.6369,
  [2605] = 0.0146,
} end
