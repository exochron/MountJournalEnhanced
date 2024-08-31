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
local MINOR = 370
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
  [6] = 64.4751,
  [9] = 67.9483,
  [11] = 66.3739,
  [14] = 66.3679,
  [17] = 89.2596,
  [18] = 71.8824,
  [19] = 71.8789,
  [20] = 64.4698,
  [21] = 63.4359,
  [24] = 57.6701,
  [25] = 56.602,
  [26] = 66.5749,
  [27] = 63.4389,
  [31] = 62.2067,
  [34] = 69.5687,
  [36] = 57.6707,
  [38] = 56.6052,
  [39] = 55.6779,
  [40] = 55.2148,
  [41] = 49.4458,
  [42] = 0.0074,
  [45] = 0.0286,
  [46] = 0.0089,
  [50] = 0.0166,
  [51] = 0.0286,
  [52] = 0.0165,
  [53] = 0.0165,
  [54] = 0.0046,
  [55] = 13.6085,
  [56] = 0.0094,
  [57] = 58.5893,
  [58] = 58.5433,
  [62] = 0.0053,
  [63] = 0.0094,
  [64] = 0.0046,
  [65] = 65.6666,
  [66] = 69.5595,
  [67] = 62.1971,
  [68] = 61.2571,
  [69] = 15.5315,
  [71] = 58.5919,
  [72] = 55.2138,
  [73] = 0.0053,
  [74] = 0.0074,
  [75] = 45.1929,
  [76] = 44.5485,
  [77] = 44.5502,
  [78] = 45.8779,
  [79] = 45.8779,
  [80] = 49.1809,
  [81] = 49.1857,
  [82] = 45.1917,
  [83] = 88.4588,
  [84] = 48.8602,
  [85] = 62.1717,
  [87] = 62.0914,
  [88] = 52.9293,
  [89] = 51.1922,
  [90] = 50.7404,
  [91] = 65.4881,
  [92] = 65.9737,
  [93] = 62.6588,
  [94] = 54.2146,
  [95] = 52.8867,
  [96] = 52.9625,
  [97] = 52.8876,
  [98] = 52.962,
  [99] = 54.2171,
  [100] = 62.1695,
  [101] = 52.9316,
  [102] = 51.1913,
  [103] = 50.7403,
  [104] = 62.6548,
  [105] = 65.4841,
  [106] = 65.9676,
  [107] = 61.2641,
  [108] = 17.8573,
  [109] = 16.0092,
  [110] = 2.0945,
  [111] = 2.0317,
  [117] = 62.2871,
  [118] = 40.2059,
  [119] = 62.4623,
  [120] = 62.2552,
  [122] = 0.0259,
  [125] = 15.4181,
  [129] = 43.5335,
  [130] = 44.4631,
  [131] = 46.1074,
  [132] = 40.2698,
  [133] = 46.8639,
  [134] = 48.8695,
  [135] = 45.9369,
  [136] = 44.5396,
  [137] = 41.5831,
  [138] = 39.0796,
  [139] = 53.0568,
  [140] = 41.4418,
  [141] = 42.1844,
  [142] = 57.7583,
  [146] = 54.2117,
  [147] = 63.5455,
  [149] = 52.1493,
  [150] = 52.6146,
  [151] = 24.4168,
  [152] = 66.205,
  [153] = 25.7446,
  [154] = 25.7901,
  [155] = 25.5572,
  [156] = 25.2126,
  [157] = 58.5457,
  [158] = 58.9972,
  [159] = 63.4581,
  [160] = 55.2505,
  [161] = 54.0651,
  [162] = 42.2998,
  [163] = 58.9952,
  [164] = 66.2065,
  [165] = 54.0632,
  [166] = 55.2503,
  [167] = 54.2114,
  [168] = 17.2268,
  [169] = 0.0609,
  [170] = 25.1196,
  [171] = 20.5399,
  [172] = 25.0726,
  [173] = 24.9972,
  [174] = 25.1399,
  [176] = 22.8259,
  [177] = 23.5303,
  [178] = 23.2106,
  [179] = 23.3598,
  [180] = 23.0297,
  [183] = 25.411,
  [185] = 25.7204,
  [186] = 28.6376,
  [187] = 26.5007,
  [188] = 26.1864,
  [189] = 25.9976,
  [190] = 26.5713,
  [191] = 26.474,
  [196] = 1.0395,
  [197] = 1.1207,
  [199] = 1.7388,
  [201] = 0.9126,
  [202] = 34.2163,
  [203] = 26.7336,
  [204] = 20.5279,
  [205] = 36.3538,
  [207] = 0.0923,
  [211] = 0.2597,
  [212] = 1.1939,
  [213] = 40.1535,
  [219] = 29.7591,
  [220] = 42.3022,
  [221] = 88.1538,
  [223] = 0.1229,
  [224] = 28.5371,
  [226] = 34.111,
  [230] = 18.9692,
  [236] = 50.8428,
  [237] = 13.9194,
  [240] = 23.1688,
  [241] = 0.105,
  [243] = 0.6931,
  [246] = 23.3118,
  [247] = 34.1051,
  [248] = 68.5017,
  [249] = 31.3084,
  [250] = 66.3812,
  [253] = 61.7014,
  [254] = 25.1736,
  [255] = 26.7586,
  [256] = 26.6206,
  [257] = 28.7681,
  [258] = 15.46,
  [259] = 15.1484,
  [262] = 29.9117,
  [263] = 0.3847,
  [264] = 18.7275,
  [265] = 7.981,
  [266] = 0.936,
  [267] = 17.0457,
  [268] = 86.6639,
  [269] = 38.8163,
  [270] = 42.1308,
  [271] = 22.1893,
  [272] = 23.9427,
  [275] = 22.5058,
  [276] = 30.0378,
  [277] = 31.6529,
  [278] = 18.5068,
  [279] = 23.9943,
  [280] = 41.2219,
  [284] = 46.017,
  [285] = 40.2605,
  [286] = 11.6311,
  [287] = 12.5714,
  [288] = 11.4083,
  [289] = 11.0205,
  [291] = 38.2972,
  [292] = 41.26,
  [293] = 39.457,
  [294] = 7.5712,
  [295] = 7.2113,
  [296] = 7.2113,
  [297] = 8.9694,
  [298] = 6.9616,
  [299] = 7.2401,
  [300] = 7.5713,
  [301] = 6.9613,
  [302] = 7.2402,
  [303] = 8.9693,
  [304] = 9.3391,
  [305] = 10.5817,
  [306] = 44.8208,
  [307] = 44.8676,
  [309] = 55.6805,
  [310] = 67.9453,
  [311] = 12.5876,
  [312] = 15.7406,
  [313] = 0.0657,
  [314] = 66.5688,
  [317] = 0.0705,
  [318] = 19.6153,
  [319] = 21.08,
  [320] = 19.6158,
  [321] = 20.1281,
  [322] = 11.0577,
  [323] = 17.9933,
  [324] = 18.2548,
  [325] = 18.2544,
  [326] = 21.0795,
  [327] = 20.1274,
  [328] = 0.9529,
  [329] = 7.2092,
  [330] = 7.4067,
  [331] = 5.8989,
  [332] = 5.4628,
  [336] = 62.0831,
  [337] = 65.6697,
  [338] = 4.0315,
  [340] = 0.0372,
  [341] = 9.8514,
  [342] = 0.8533,
  [343] = 0.6901,
  [344] = 0.0429,
  [345] = 0.0603,
  [349] = 22.9608,
  [350] = 20.7204,
  [351] = 20.1073,
  [352] = 6.0422,
  [358] = 0.0554,
  [363] = 15.9125,
  [364] = 42.4203,
  [365] = 31.6848,
  [366] = 16.8479,
  [367] = 30.4582,
  [368] = 28.5588,
  [371] = 32.5147,
  [372] = 1.099,
  [373] = 47.0876,
  [375] = 15.8028,
  [376] = 43.8128,
  [382] = 42.9051,
  [386] = 22.5102,
  [388] = 56.764,
  [389] = 49.9199,
  [391] = 19.4458,
  [392] = 23.4567,
  [393] = 8.3576,
  [394] = 19.2901,
  [395] = 20.992,
  [396] = 11.0012,
  [397] = 19.816,
  [398] = 35.9615,
  [399] = 35.7911,
  [400] = 4.3813,
  [401] = 60.5422,
  [403] = 40.4348,
  [404] = 5.5738,
  [405] = 8.9332,
  [406] = 9.1921,
  [407] = 47.9342,
  [408] = 0.5553,
  [409] = 44.5268,
  [410] = 10.4932,
  [411] = 13.1937,
  [412] = 0.5534,
  [413] = 20.2706,
  [415] = 22.4971,
  [416] = 29.1368,
  [417] = 37.4871,
  [418] = 0.5435,
  [419] = 48.8057,
  [420] = 37.1767,
  [421] = 18.0052,
  [422] = 5.0056,
  [423] = 5.7142,
  [424] = 0.0445,
  [425] = 24.5978,
  [426] = 16.0544,
  [428] = 0.0321,
  [429] = 13.7067,
  [430] = 30.4818,
  [431] = 22.2013,
  [432] = 18.6804,
  [433] = 0.5004,
  [434] = 19.2751,
  [435] = 56.7546,
  [436] = 49.911,
  [439] = 42.1254,
  [440] = 16.858,
  [441] = 17.0741,
  [442] = 9.7759,
  [443] = 23.776,
  [444] = 10.9438,
  [445] = 8.9011,
  [446] = 19.176,
  [447] = 34.6449,
  [448] = 42.7412,
  [449] = 35.3084,
  [450] = 9.5212,
  [451] = 14.7641,
  [452] = 48.4564,
  [453] = 45.2592,
  [454] = 37.6017,
  [455] = 14.5157,
  [456] = 20.9774,
  [457] = 18.9031,
  [458] = 21.023,
  [459] = 18.6324,
  [460] = 50.5852,
  [462] = 13.7859,
  [463] = 21.0134,
  [464] = 44.255,
  [465] = 43.1408,
  [466] = 44.4931,
  [467] = 0.0292,
  [468] = 18.2842,
  [469] = 11.735,
  [470] = 11.1423,
  [471] = 29.9304,
  [472] = 9.9806,
  [473] = 17.4725,
  [474] = 9.3078,
  [475] = 14.8274,
  [476] = 20.503,
  [477] = 22.1216,
  [478] = 25.3971,
  [479] = 29.2827,
  [480] = 26.7711,
  [481] = 26.7511,
  [482] = 14.1162,
  [484] = 13.921,
  [485] = 13.5655,
  [486] = 39.3701,
  [487] = 39.5521,
  [488] = 4.5723,
  [492] = 50.962,
  [493] = 48.9351,
  [494] = 48.0625,
  [495] = 49.4438,
  [496] = 53.4154,
  [497] = 43.6052,
  [498] = 44.9927,
  [499] = 44.0548,
  [500] = 43.2052,
  [501] = 43.8923,
  [503] = 7.1653,
  [504] = 19.3498,
  [505] = 27.0664,
  [506] = 30.5555,
  [507] = 27.3581,
  [508] = 25.4,
  [509] = 35.6998,
  [510] = 21.9877,
  [511] = 23.3042,
  [515] = 11.7535,
  [516] = 9.5272,
  [517] = 33.403,
  [518] = 7.1596,
  [519] = 7.1582,
  [520] = 7.1573,
  [521] = 51.7482,
  [522] = 52.4661,
  [523] = 34.377,
  [526] = 10.3919,
  [527] = 10.1751,
  [528] = 13.8764,
  [529] = 13.4858,
  [530] = 8.7693,
  [531] = 18.5717,
  [532] = 0.6082,
  [533] = 11.0332,
  [534] = 17.5161,
  [535] = 20.2557,
  [536] = 17.7705,
  [537] = 20.8737,
  [538] = 32.0116,
  [539] = 32.1891,
  [540] = 32.0136,
  [541] = 0.0198,
  [542] = 12.7688,
  [543] = 19.1587,
  [544] = 27.6093,
  [545] = 10.8012,
  [546] = 11.1103,
  [547] = 64.0799,
  [548] = 23.8505,
  [549] = 22.7235,
  [550] = 9.452,
  [551] = 16.076,
  [552] = 21.9075,
  [554] = 5.9637,
  [555] = 7.0454,
  [557] = 10.6319,
  [558] = 13.9334,
  [559] = 16.279,
  [560] = 5.0898,
  [561] = 20.2596,
  [562] = 0.023,
  [563] = 0.0445,
  [564] = 0.0668,
  [568] = 5.7174,
  [571] = 11.8408,
  [593] = 15.3861,
  [594] = 9.8905,
  [600] = 24.3855,
  [603] = 16.1921,
  [606] = 31.5171,
  [607] = 5.0639,
  [608] = 22.9337,
  [609] = 24.9174,
  [611] = 13.919,
  [612] = 17.3407,
  [613] = 7.9019,
  [614] = 25.7448,
  [615] = 25.0758,
  [616] = 4.7075,
  [617] = 9.0378,
  [618] = 7.0531,
  [619] = 20.0955,
  [620] = 25.1188,
  [621] = 17.3316,
  [622] = 13.9392,
  [623] = 7.7219,
  [624] = 18.3012,
  [625] = 13.9304,
  [626] = 4.7155,
  [627] = 21.9575,
  [628] = 25.0622,
  [629] = 24.749,
  [630] = 16.7826,
  [631] = 36.1962,
  [632] = 8.0189,
  [633] = 7.423,
  [634] = 2.6131,
  [635] = 14.7365,
  [636] = 25.8908,
  [637] = 24.81,
  [638] = 4.946,
  [639] = 5.2255,
  [640] = 3.8104,
  [641] = 5.0366,
  [642] = 4.7232,
  [643] = 13.9459,
  [644] = 12.2295,
  [645] = 7.3844,
  [646] = 27.0676,
  [647] = 24.8995,
  [648] = 9.6076,
  [649] = 4.7323,
  [650] = 12.3213,
  [651] = 49.357,
  [652] = 8.6916,
  [654] = 5.2765,
  [655] = 16.9795,
  [656] = 29.2459,
  [657] = 59.9662,
  [663] = 1.7741,
  [664] = 5.5622,
  [678] = 41.9806,
  [679] = 38.5259,
  [682] = 5.2522,
  [741] = 13.8791,
  [751] = 8.5824,
  [753] = 23.8037,
  [755] = 3.4372,
  [756] = 4.1089,
  [758] = 10.2148,
  [759] = 0.0505,
  [760] = 0.0252,
  [761] = 0.0468,
  [762] = 66.9954,
  [763] = 26.033,
  [764] = 24.0594,
  [765] = 9.4009,
  [768] = 18.6901,
  [769] = 13.1755,
  [772] = 37.6308,
  [773] = 8.0089,
  [775] = 4.9711,
  [778] = 13.8468,
  [779] = 25.8686,
  [780] = 88.1667,
  [781] = 24.1706,
  [784] = 5.3165,
  [791] = 4.6689,
  [793] = 6.5316,
  [794] = 6.1495,
  [795] = 6.8773,
  [796] = 6.2953,
  [797] = 28.8676,
  [800] = 9.8045,
  [802] = 10.0239,
  [803] = 6.4971,
  [804] = 7.8411,
  [826] = 48.8002,
  [831] = 6.18,
  [832] = 7.7866,
  [833] = 25.4115,
  [834] = 14.8346,
  [836] = 3.1386,
  [838] = 15.5221,
  [841] = 3.6072,
  [842] = 4.2479,
  [843] = 3.6432,
  [844] = 3.0379,
  [845] = 18.0848,
  [846] = 8.7569,
  [847] = 12.647,
  [848] = 0.0465,
  [849] = 0.0341,
  [850] = 0.0248,
  [851] = 0.0306,
  [852] = 0.0315,
  [853] = 0.0382,
  [854] = 7.554,
  [855] = 18.1399,
  [860] = 14.1454,
  [861] = 12.2375,
  [864] = 13.6519,
  [865] = 17.5217,
  [866] = 16.1793,
  [867] = 14.9766,
  [868] = 16.614,
  [870] = 10.7642,
  [872] = 11.259,
  [873] = 3.7366,
  [874] = 4.3027,
  [875] = 9.3959,
  [876] = 3.4313,
  [877] = 1.1215,
  [878] = 9.847,
  [881] = 38.2403,
  [882] = 3.641,
  [883] = 32.4342,
  [884] = 12.8076,
  [885] = 18.7272,
  [888] = 15.0139,
  [889] = 8.2127,
  [890] = 8.3161,
  [891] = 8.1537,
  [892] = 14.066,
  [893] = 13.4313,
  [894] = 13.1674,
  [896] = 18.3053,
  [898] = 14.5295,
  [899] = 12.181,
  [900] = 3.4312,
  [901] = 3.7175,
  [905] = 11.2902,
  [906] = 28.654,
  [926] = 15.3379,
  [928] = 10.0459,
  [930] = 10.9927,
  [931] = 9.5616,
  [932] = 7.5849,
  [933] = 3.9456,
  [937] = 0.0327,
  [939] = 22.3508,
  [941] = 10.0166,
  [942] = 10.3082,
  [943] = 9.3559,
  [944] = 12.2471,
  [945] = 4.3908,
  [946] = 4.9757,
  [947] = 22.5427,
  [948] = 0.0411,
  [949] = 11.8274,
  [954] = 3.9903,
  [955] = 15.7421,
  [956] = 17.677,
  [958] = 6.0299,
  [959] = 6.0456,
  [960] = 6.054,
  [961] = 19.3768,
  [962] = 5.2409,
  [963] = 8.1256,
  [964] = 22.3102,
  [965] = 22.7883,
  [966] = 21.5551,
  [967] = 21.7122,
  [968] = 21.5309,
  [970] = 14.8821,
  [971] = 14.8997,
  [972] = 11.1633,
  [973] = 11.6687,
  [974] = 28.677,
  [975] = 28.6799,
  [976] = 28.6667,
  [978] = 25.4249,
  [979] = 17.4982,
  [980] = 11.6374,
  [981] = 18.5296,
  [982] = 1.9667,
  [983] = 11.5076,
  [984] = 11.6651,
  [985] = 11.6182,
  [986] = 27.3195,
  [993] = 7.4354,
  [994] = 11.7724,
  [995] = 14.7066,
  [996] = 17.8718,
  [997] = 18.7838,
  [999] = 30.6292,
  [1006] = 38.685,
  [1007] = 38.9949,
  [1008] = 36.3887,
  [1009] = 40.5564,
  [1010] = 12.3453,
  [1011] = 10.0771,
  [1012] = 2.6413,
  [1013] = 10.0877,
  [1015] = 9.7963,
  [1016] = 9.8339,
  [1018] = 4.3751,
  [1019] = 6.1069,
  [1025] = 10.957,
  [1026] = 3.3005,
  [1027] = 3.001,
  [1028] = 10.7312,
  [1030] = 0.2654,
  [1031] = 0.0932,
  [1032] = 0.0902,
  [1035] = 0.3889,
  [1038] = 38.8941,
  [1039] = 4.0936,
  [1040] = 8.7538,
  [1042] = 9.6163,
  [1043] = 4.8231,
  [1044] = 38.4014,
  [1045] = 4.9694,
  [1046] = 11.9896,
  [1047] = 12.1982,
  [1048] = 36.451,
  [1049] = 27.8768,
  [1050] = 4.4525,
  [1051] = 38.3406,
  [1053] = 12.1111,
  [1054] = 25.9168,
  [1057] = 5.434,
  [1058] = 17.5228,
  [1059] = 3.7955,
  [1060] = 4.0468,
  [1061] = 12.9911,
  [1062] = 3.691,
  [1063] = 3.6892,
  [1064] = 4.2168,
  [1166] = 13.1587,
  [1167] = 16.895,
  [1168] = 22.7657,
  [1169] = 12.1591,
  [1172] = 2.4523,
  [1173] = 14.1485,
  [1174] = 13.7283,
  [1175] = 8.3683,
  [1176] = 10.5228,
  [1178] = 8.6028,
  [1179] = 1.3423,
  [1180] = 19.2203,
  [1182] = 17.8194,
  [1183] = 17.6849,
  [1185] = 18.0865,
  [1190] = 7.5357,
  [1191] = 12.9215,
  [1192] = 0.7885,
  [1193] = 10.594,
  [1194] = 5.784,
  [1195] = 3.5877,
  [1196] = 4.1798,
  [1197] = 6.9884,
  [1198] = 29.8,
  [1199] = 17.4692,
  [1200] = 16.2943,
  [1201] = 3.5906,
  [1203] = 16.483,
  [1204] = 12.0998,
  [1205] = 17.7421,
  [1206] = 2.0489,
  [1207] = 1.5867,
  [1208] = 8.1207,
  [1209] = 12.7845,
  [1210] = 6.569,
  [1211] = 13.1349,
  [1212] = 7.6172,
  [1213] = 5.1695,
  [1214] = 12.1755,
  [1215] = 12.7566,
  [1216] = 7.9169,
  [1217] = 4.3999,
  [1218] = 6.8085,
  [1219] = 13.7688,
  [1220] = 11.9423,
  [1221] = 8.1737,
  [1222] = 13.0527,
  [1223] = 17.8483,
  [1224] = 54.9933,
  [1225] = 17.3139,
  [1227] = 12.7887,
  [1229] = 3.9999,
  [1230] = 11.8129,
  [1231] = 10.8984,
  [1232] = 5.4225,
  [1237] = 9.0785,
  [1238] = 5.2531,
  [1239] = 42.9671,
  [1240] = 31.9917,
  [1242] = 8.7598,
  [1243] = 12.2402,
  [1245] = 23.9789,
  [1246] = 23.9789,
  [1247] = 3.9263,
  [1248] = 5.7254,
  [1249] = 8.1778,
  [1250] = 6.2461,
  [1252] = 6.3284,
  [1253] = 33.9704,
  [1254] = 2.2673,
  [1255] = 16.7466,
  [1256] = 16.7466,
  [1257] = 1.9684,
  [1258] = 5.7072,
  [1259] = 13.775,
  [1260] = 12.8592,
  [1262] = 4.1492,
  [1265] = 35.0335,
  [1266] = 12.3577,
  [1267] = 12.34,
  [1282] = 22.3795,
  [1283] = 25.4792,
  [1285] = 11.9955,
  [1286] = 39.6767,
  [1287] = 6.8024,
  [1288] = 10.9329,
  [1289] = 68.5303,
  [1290] = 19.4864,
  [1291] = 25.7704,
  [1292] = 10.8831,
  [1293] = 3.11,
  [1297] = 5.8778,
  [1298] = 2.6874,
  [1299] = 47.1041,
  [1302] = 72.5879,
  [1303] = 55.7536,
  [1304] = 2.9909,
  [1305] = 20.0861,
  [1306] = 13.4,
  [1307] = 9.9362,
  [1309] = 19.2695,
  [1310] = 13.6136,
  [1311] = 13.6272,
  [1312] = 9.2137,
  [1313] = 5.455,
  [1314] = 5.3584,
  [1315] = 18.2517,
  [1317] = 3.8714,
  [1318] = 12.1877,
  [1319] = 6.5472,
  [1320] = 11.9747,
  [1321] = 4.9198,
  [1322] = 5.4128,
  [1324] = 9.8263,
  [1326] = 16.2339,
  [1327] = 3.9193,
  [1328] = 4.8622,
  [1329] = 10.3316,
  [1330] = 12.7023,
  [1332] = 8.2103,
  [1346] = 19.6429,
  [1350] = 19.4177,
  [1351] = 6.7402,
  [1352] = 8.2677,
  [1354] = 16.2647,
  [1355] = 7.0974,
  [1356] = 5.6096,
  [1357] = 63.701,
  [1358] = 4.1121,
  [1359] = 6.3203,
  [1360] = 36.1219,
  [1361] = 20.3104,
  [1362] = 30.5187,
  [1363] = 0.4136,
  [1364] = 54.7991,
  [1365] = 13.232,
  [1366] = 2.0333,
  [1367] = 4.2269,
  [1368] = 44.287,
  [1369] = 55.6068,
  [1370] = 7.5707,
  [1371] = 3.6096,
  [1372] = 4.238,
  [1373] = 4.4773,
  [1375] = 14.7486,
  [1376] = 7.6236,
  [1377] = 8.7901,
  [1378] = 13.9705,
  [1379] = 3.5424,
  [1382] = 1.8151,
  [1384] = 15.0881,
  [1385] = 52.1689,
  [1387] = 1.5038,
  [1388] = 58.0451,
  [1389] = 2.8679,
  [1391] = 7.1733,
  [1392] = 7.0963,
  [1393] = 15.3697,
  [1394] = 5.5466,
  [1395] = 9.1486,
  [1396] = 56.5778,
  [1397] = 32.8146,
  [1398] = 14.517,
  [1399] = 59.3479,
  [1400] = 52.7099,
  [1401] = 2.3079,
  [1402] = 2.1585,
  [1404] = 11.5581,
  [1405] = 19.1266,
  [1406] = 11.2366,
  [1407] = 11.1725,
  [1408] = 8.3147,
  [1409] = 4.279,
  [1410] = 5.132,
  [1411] = 9.976,
  [1413] = 8.5328,
  [1414] = 18.9272,
  [1415] = 45.8252,
  [1416] = 16.3407,
  [1417] = 6.243,
  [1419] = 20.8976,
  [1420] = 6.0456,
  [1421] = 18.241,
  [1422] = 17.7832,
  [1423] = 18.8274,
  [1424] = 9.1961,
  [1425] = 16.2258,
  [1426] = 3.2492,
  [1428] = 23.0805,
  [1429] = 6.5241,
  [1430] = 5.3459,
  [1431] = 5.558,
  [1433] = 3.1678,
  [1434] = 8.9619,
  [1436] = 4.3703,
  [1437] = 26.7765,
  [1438] = 11.4698,
  [1439] = 11.4697,
  [1440] = 11.4554,
  [1441] = 2.9384,
  [1442] = 19.2146,
  [1443] = 4.1091,
  [1444] = 13.5341,
  [1445] = 16.8051,
  [1446] = 20.053,
  [1448] = 4.9468,
  [1449] = 9.8988,
  [1450] = 14.2862,
  [1451] = 3.8094,
  [1452] = 3.5106,
  [1454] = 8.5436,
  [1455] = 10.9485,
  [1456] = 24.1599,
  [1458] = 90.0695,
  [1459] = 5.7504,
  [1460] = 4.971,
  [1465] = 2.8813,
  [1466] = 3.0454,
  [1467] = 8.3057,
  [1468] = 17.0809,
  [1469] = 18.8605,
  [1471] = 2.6053,
  [1474] = 4.061,
  [1475] = 11.9824,
  [1476] = 13.3207,
  [1477] = 14.0091,
  [1478] = 6.0077,
  [1480] = 0.5614,
  [1481] = 15.5012,
  [1484] = 60.7617,
  [1485] = 16.3975,
  [1486] = 4.9527,
  [1487] = 13.134,
  [1489] = 15.6928,
  [1490] = 55.1979,
  [1491] = 4.4994,
  [1492] = 56.644,
  [1493] = 13.1437,
  [1494] = 13.1251,
  [1495] = 53.2476,
  [1496] = 12.9968,
  [1497] = 4.2604,
  [1500] = 6.49,
  [1501] = 9.165,
  [1502] = 10.5189,
  [1503] = 9.3273,
  [1504] = 4.3796,
  [1505] = 16.6066,
  [1506] = 12.2227,
  [1507] = 8.4743,
  [1508] = 10.9713,
  [1509] = 6.1563,
  [1510] = 16.5725,
  [1511] = 13.2046,
  [1513] = 28.6027,
  [1514] = 20.0261,
  [1517] = 4.6071,
  [1520] = 20.3621,
  [1521] = 12.3506,
  [1522] = 15.3159,
  [1523] = 2.7621,
  [1524] = 2.4586,
  [1525] = 4.9682,
  [1526] = 26.153,
  [1528] = 3.8752,
  [1529] = 29.266,
  [1531] = 24.2949,
  [1532] = 2.0707,
  [1533] = 6.0228,
  [1534] = 4.5585,
  [1535] = 2.7353,
  [1536] = 2.0296,
  [1537] = 6.4037,
  [1538] = 3.9103,
  [1539] = 2.1097,
  [1540] = 4.695,
  [1541] = 5.269,
  [1542] = 6.8399,
  [1543] = 4.0367,
  [1544] = 21.2015,
  [1545] = 6.7407,
  [1546] = 3.7807,
  [1547] = 2.9723,
  [1549] = 5.0584,
  [1551] = 7.262,
  [1552] = 17.0147,
  [1553] = 1.0663,
  [1556] = 55.3498,
  [1563] = 83.4645,
  [1564] = 9.5924,
  [1565] = 11.7146,
  [1566] = 22.871,
  [1568] = 17.59,
  [1569] = 21.3778,
  [1570] = 2.9977,
  [1571] = 2.4418,
  [1572] = 0.2328,
  [1573] = 29.5539,
  [1574] = 28.6267,
  [1575] = 35.2281,
  [1576] = 21.2326,
  [1577] = 45.1235,
  [1580] = 6.4815,
  [1581] = 26.9242,
  [1582] = 35.9457,
  [1583] = 2.5076,
  [1584] = 6.4811,
  [1585] = 9.7572,
  [1586] = 16.7433,
  [1587] = 1.4263,
  [1588] = 57.2263,
  [1589] = 87.5878,
  [1590] = 84.3212,
  [1591] = 81.1482,
  [1594] = 25.808,
  [1596] = 34.09,
  [1597] = 7.9033,
  [1599] = 0.0692,
  [1600] = 9.1575,
  [1602] = 6.7751,
  [1603] = 13.519,
  [1612] = 15.4099,
  [1614] = 3.4326,
  [1615] = 19.1329,
  [1616] = 17.0133,
  [1617] = 11.5337,
  [1618] = 4.8674,
  [1619] = 20.4181,
  [1621] = 4.57,
  [1622] = 38.0487,
  [1623] = 6.0564,
  [1626] = 3.0924,
  [1627] = 3.0204,
  [1629] = 6.2812,
  [1633] = 4.4477,
  [1634] = 9.557,
  [1635] = 28.3246,
  [1638] = 6.275,
  [1639] = 16.738,
  [1644] = 6.6189,
  [1645] = 9.6802,
  [1651] = 3.9794,
  [1653] = 13.5922,
  [1654] = 7.4121,
  [1655] = 14.54,
  [1656] = 5.7394,
  [1657] = 17.6257,
  [1658] = 9.428,
  [1659] = 17.9282,
  [1660] = 0.1541,
  [1662] = 9.2137,
  [1664] = 29.6729,
  [1665] = 28.968,
  [1667] = 29.5587,
  [1668] = 29.3072,
  [1669] = 5.0752,
  [1671] = 15.0583,
  [1672] = 12.1316,
  [1674] = 16.809,
  [1679] = 38.6775,
  [1681] = 30.0782,
  [1683] = 35.318,
  [1684] = 41.807,
  [1685] = 33.406,
  [1686] = 45.4146,
  [1688] = 3.4445,
  [1689] = 3.6231,
  [1692] = 23.7597,
  [1698] = 1.7655,
  [1699] = 11.4019,
  [1725] = 26.712,
  [1727] = 3.7798,
  [1729] = 4.4237,
  [1730] = 6.3942,
  [1732] = 1.3899,
  [1733] = 6.1404,
  [1734] = 5.531,
  [1735] = 19.0136,
  [1736] = 8.5608,
  [1737] = 8.5392,
  [1738] = 14.6122,
  [1739] = 0.171,
  [1740] = 2.1985,
  [1741] = 2.1759,
  [1742] = 19.1657,
  [1744] = 42.4468,
  [1772] = 26.0471,
  [1773] = 27.5566,
  [1774] = 2.9791,
  [1776] = 21.5419,
  [1777] = 22.404,
  [1778] = 15.3885,
  [1779] = 18.6398,
  [1781] = 15.5058,
  [1782] = 15.5287,
  [1783] = 19.3323,
  [1784] = 25.5082,
  [1785] = 13.138,
  [1792] = 25.1392,
  [1794] = 9.3146,
  [1795] = 20.3708,
  [1797] = 11.4021,
  [1798] = 28.8236,
  [1799] = 29.239,
  [1801] = 29.3821,
  [1808] = 25.4317,
  [1809] = 23.6374,
  [1810] = 25.6686,
  [1811] = 23.8436,
  [1812] = 4.9335,
  [1813] = 7.2867,
  [1814] = 5.6546,
  [1815] = 33.4729,
  [1816] = 26.1084,
  [1817] = 25.8987,
  [1818] = 2.1835,
  [1819] = 1.8398,
  [1820] = 1.8088,
  [1822] = 0.1367,
  [1825] = 3.0559,
  [1830] = 56.8597,
  [1831] = 0.1357,
  [1833] = 25.9675,
  [1834] = 6.1177,
  [1835] = 26.1465,
  [1837] = 18.3634,
  [1838] = 24.0819,
  [1839] = 24.7563,
  [1841] = 30.0997,
  [1938] = 17.8666,
  [1939] = 18.1312,
  [1940] = 24.1101,
  [1941] = 6.1023,
  [1942] = 20.5532,
  [1944] = 1.1327,
  [1949] = 26.1658,
  [1956] = 24.1875,
  [1958] = 2.6919,
  [1959] = 15.3642,
  [2023] = 5.2503,
  [2035] = 24.8587,
  [2038] = 7.7786,
  [2039] = 16.5998,
  [2055] = 18.2585,
  [2056] = 0.7828,
  [2057] = 0.7031,
  [2060] = 16.2197,
  [2063] = 15.3913,
  [2064] = 16.074,
  [2065] = 11.946,
  [2067] = 12.0317,
  [2068] = 12.438,
  [2069] = 16.1088,
  [2070] = 12.3577,
  [2071] = 12.9532,
  [2072] = 14.3225,
  [2073] = 14.1838,
  [2074] = 14.1994,
  [2075] = 14.026,
  [2076] = 14.0045,
  [2077] = 13.9323,
  [2078] = 14.4649,
  [2080] = 14.6801,
  [2081] = 13.3391,
  [2083] = 13.5599,
  [2084] = 12.7853,
  [2085] = 14.1852,
  [2086] = 13.7078,
  [2087] = 15.229,
  [2088] = 14.3304,
  [2089] = 14.0423,
  [2090] = 10.7368,
  [2091] = 15.4941,
  [2114] = 2.2019,
  [2116] = 3.1034,
  [2117] = 2.8105,
  [2118] = 12.4878,
  [2140] = 8.3787,
  [2142] = 29.4991,
  [2143] = 14.2271,
  [2144] = 0.0449,
  [2152] = 20.7392,
  [2158] = 0.0011,
  [2159] = 0.0004,
  [2165] = 0.0345,
  [2176] = 0.0089,
  [2177] = 0.0005,
  [2181] = 0.3381,
  [2184] = 0.0005,
  [2188] = 0.0023,
  [2189] = 12.9617,
  [2192] = 0.0088,
  [2194] = 0.0502,
  [2198] = 5.0652,
  [2201] = 5.1601,
  [2205] = 0.0069,
  [2222] = 0.0123,
} end
