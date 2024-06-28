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
local MINOR = 307
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
  [6] = 64.36544724670863,
  [9] = 67.82683019621157,
  [11] = 66.26861928540842,
  [14] = 66.26196573249646,
  [17] = 88.8827661037306,
  [18] = 71.78970337096287,
  [19] = 71.78586478274444,
  [20] = 64.35964671340076,
  [21] = 63.265051957424085,
  [24] = 57.508449159178575,
  [25] = 56.4377389521166,
  [26] = 66.48758941778,
  [27] = 63.26803752603843,
  [31] = 62.08771429985004,
  [34] = 69.41609102060383,
  [36] = 57.509302178782676,
  [38] = 56.44140693641421,
  [39] = 55.53635313646778,
  [40] = 55.067533562056326,
  [41] = 49.00870591807941,
  [42] = 0.007250666634820602,
  [45] = 0.028234948895595517,
  [46] = 0.00887140388260403,
  [50] = 0.016377976398653595,
  [51] = 0.02832025085600517,
  [52] = 0.01629267443824394,
  [53] = 0.016122070517424633,
  [54] = 0.004606305862121323,
  [55] = 13.454251705612698,
  [56] = 0.009297913684652302,
  [57] = 58.42297147673048,
  [58] = 58.376823116148856,
  [62] = 0.005374023505808211,
  [63] = 0.009297913684652302,
  [64] = 0.004606305862121323,
  [65] = 65.54585577485742,
  [66] = 69.40594008731509,
  [67] = 62.07781927244252,
  [68] = 61.11680738646736,
  [69] = 15.414405453866141,
  [71] = 58.42561583750318,
  [72] = 55.066595240491814,
  [73] = 0.005374023505808211,
  [74] = 0.007250666634820602,
  [75] = 45.04497972372401,
  [76] = 44.40282656576014,
  [77] = 44.4042766990871,
  [78] = 45.73038097561558,
  [79] = 45.7305515795364,
  [80] = 49.05596320414636,
  [81] = 49.06039890608766,
  [82] = 45.04412670411991,
  [83] = 88.04006803684362,
  [84] = 48.39956461879407,
  [85] = 62.03354755498991,
  [87] = 61.968462159197344,
  [88] = 52.76369821531238,
  [89] = 51.019273124934955,
  [90] = 50.565040185753546,
  [91] = 65.36655105407633,
  [92] = 65.85464887154036,
  [93] = 62.5212188626519,
  [94] = 54.036915276386885,
  [95] = 52.70501046655054,
  [96] = 52.783061760325374,
  [97] = 52.70569288223382,
  [98] = 52.78272055248374,
  [99] = 54.04007144892204,
  [100] = 62.03158560990049,
  [101] = 52.76668378392672,
  [102] = 51.01773768964758,
  [103] = 50.564443072030684,
  [104] = 62.516868462671006,
  [105] = 65.36168884233298,
  [106] = 65.84850713039087,
  [107] = 61.12388744918136,
  [108] = 17.75765030631934,
  [109] = 15.837076667695976,
  [110] = 2.083159175164164,
  [111] = 2.0239596146398635,
  [117] = 62.11756998599342,
  [118] = 39.985720451827426,
  [119] = 62.30173691851786,
  [120] = 62.08728779004799,
  [122] = 0.02559058812289624,
  [125] = 9.543327424750876,
  [129] = 43.2105610651144,
  [130] = 44.170890535406286,
  [131] = 45.83146379870102,
  [132] = 39.95893563625879,
  [133] = 46.731314179062466,
  [134] = 48.79434209156995,
  [135] = 45.82173937521432,
  [136] = 44.407262267701434,
  [137] = 41.27139159912173,
  [138] = 38.75396014351202,
  [139] = 52.63489225509381,
  [140] = 41.27360945009238,
  [141] = 42.02537562718266,
  [142] = 57.62659237434595,
  [146] = 54.026508437216904,
  [147] = 63.38123322750204,
  [149] = 51.8838084936868,
  [150] = 52.37361235035904,
  [151] = 24.246826340562958,
  [152] = 66.04325150600611,
  [153] = 25.559879417148764,
  [154] = 25.608245628701038,
  [155] = 25.375456578743094,
  [156] = 25.02836290183621,
  [157] = 58.378699759277865,
  [158] = 58.84632510624359,
  [159] = 63.28450080439749,
  [160] = 55.06838658166042,
  [161] = 53.870405849667236,
  [162] = 42.16185876383811,
  [163] = 58.84419255723335,
  [164] = 66.04470163933307,
  [165] = 53.86793209281536,
  [166] = 55.06796007185837,
  [167] = 54.02608192741486,
  [168] = 17.100313399402545,
  [169] = 0.06005258012839651,
  [170] = 24.933848329702315,
  [171] = 20.38648612222406,
  [172] = 24.88787057304151,
  [173] = 24.810075185147905,
  [174] = 24.954832611963088,
  [176] = 22.64835290444645,
  [177] = 23.356956289569446,
  [178] = 23.03349125569604,
  [179] = 23.185328745225224,
  [180] = 22.851200966300606,
  [183] = 25.04098759197684,
  [185] = 25.565253440654573,
  [186] = 28.432934745706326,
  [187] = 26.290149500215815,
  [188] = 25.98050338392877,
  [189] = 25.78541780047189,
  [190] = 26.35975589991009,
  [191] = 26.26455891209292,
  [196] = 1.0342862699670563,
  [197] = 1.118479304891385,
  [199] = 1.7349565727719554,
  [201] = 0.8979737372324291,
  [202] = 34.1203576540596,
  [203] = 26.55978899707073,
  [204] = 20.4168536201299,
  [205] = 36.20121367629271,
  [207] = 0.09152900351955888,
  [211] = 0.25752661847674585,
  [212] = 1.1820292653965774,
  [213] = 39.75267549598825,
  [219] = 29.60532488957661,
  [220] = 42.16399131284835,
  [221] = 87.76078941846241,
  [223] = 0.12215240730662472,
  [224] = 27.83948900713636,
  [226] = 33.994963772257414,
  [230] = 18.432303511199294,
  [236] = 50.67550622448405,
  [237] = 13.82898321769231,
  [240] = 23.00568281660249,
  [241] = 0.10389778777895874,
  [243] = 0.6822450793564138,
  [246] = 23.160335270825193,
  [247] = 33.94506212541776,
  [248] = 68.39639138586683,
  [249] = 31.10826013003431,
  [250] = 66.28832403826304,
  [253] = 61.57436710210474,
  [254] = 24.94024597673304,
  [255] = 26.61677070662438,
  [256] = 26.294670504117526,
  [257] = 28.551675074596563,
  [258] = 15.31093417588923,
  [259] = 14.954371981376877,
  [262] = 29.72150615965456,
  [263] = 0.3841147277246726,
  [264] = 18.626791980933305,
  [265] = 7.848462773371458,
  [266] = 0.9330328429607969,
  [267] = 16.826835314329195,
  [268] = 86.1223946648742,
  [269] = 38.50649915636361,
  [270] = 42.00063805866387,
  [271] = 21.996219417114645,
  [272] = 23.835585589428018,
  [275] = 22.25366073363098,
  [276] = 29.702825030324846,
  [277] = 31.427374763926824,
  [278] = 18.38129293887432,
  [279] = 23.894614546031498,
  [280] = 40.89452753803188,
  [284] = 45.90840616699053,
  [285] = 40.10957889834224,
  [286] = 11.49563339264663,
  [287] = 12.468331647197916,
  [288] = 11.267706554432033,
  [289] = 10.861072109159213,
  [291] = 37.51597279208671,
  [292] = 40.63324763329711,
  [293] = 39.235319106103695,
  [294] = 7.509643386624312,
  [295] = 7.153678305834824,
  [296] = 7.1534223999535955,
  [297] = 8.897335678568565,
  [298] = 6.9034023539929,
  [299] = 7.173724266531093,
  [300] = 7.509899292505541,
  [301] = 6.90331705203249,
  [302] = 7.173980172412322,
  [303] = 8.897335678568565,
  [304] = 9.207834814459705,
  [305] = 10.499562400943098,
  [306] = 44.662571035207534,
  [307] = 44.71110785068063,
  [309] = 55.538826893319666,
  [310] = 67.82324751387436,
  [311] = 12.466966815831361,
  [312] = 15.660331005727173,
  [313] = 0.06500009383215645,
  [314] = 66.48195948839296,
  [317] = 0.06977700361509709,
  [318] = 19.46667508312676,
  [319] = 20.921244112032184,
  [320] = 19.46710159292881,
  [321] = 19.97669550441608,
  [322] = 10.937843873527902,
  [323] = 17.850288235324225,
  [324] = 18.10499988910745,
  [325] = 18.104829285186632,
  [326] = 20.920902904190545,
  [327] = 19.976268994614035,
  [328] = 0.9476194781908478,
  [329] = 7.118022086383589,
  [330] = 7.330338665843218,
  [331] = 5.825100272454462,
  [332] = 5.395946109633492,
  [336] = 61.96061437883966,
  [337] = 65.54935315523421,
  [338] = 3.973706523723328,
  [340] = 0.03676514493656093,
  [341] = 9.770998357084242,
  [342] = 0.850631149205071,
  [343] = 0.6894104440308247,
  [344] = 0.042309772363188454,
  [345] = 0.05937016444511928,
  [349] = 22.772126049000857,
  [350] = 20.345711785148247,
  [351] = 19.717121638889505,
  [352] = 5.936163424907831,
  [358] = 0.05510506642463657,
  [363] = 15.731728746590054,
  [364] = 42.23735099880066,
  [365] = 31.47079346177534,
  [366] = 16.71901363637139,
  [367] = 29.866007680588517,
  [368] = 27.893314544154855,
  [371] = 28.95523864929464,
  [372] = 1.0878559011043192,
  [373] = 46.982187244627255,
  [375] = 15.691722127157925,
  [376] = 42.32052041020007,
  [382] = 41.64390526023069,
  [386] = 22.400806615337633,
  [388] = 56.61064602586697,
  [389] = 49.75859545204068,
  [391] = 19.349470189523895,
  [392] = 23.328550736753034,
  [393] = 8.205195571804632,
  [394] = 19.216057923443195,
  [395] = 20.76164414410572,
  [396] = 10.917627308910813,
  [397] = 19.63907034511467,
  [398] = 35.80890996036871,
  [399] = 35.63728241602448,
  [400] = 4.314146647718258,
  [401] = 60.54528425172267,
  [403] = 40.18251207449249,
  [404] = 5.5356707207845055,
  [405] = 8.85195503563063,
  [406] = 9.123556477574967,
  [407] = 47.81123699784868,
  [408] = 0.5544627426627519,
  [409] = 44.46356156157181,
  [410] = 10.393190856312259,
  [411] = 13.059388930876409,
  [412] = 0.553695025019065,
  [413] = 20.113690452833985,
  [415] = 22.366174019411314,
  [416] = 27.59808445917704,
  [417] = 37.34562477714863,
  [418] = 0.5439706015323644,
  [419] = 48.66237995881621,
  [420] = 36.76744808949199,
  [421] = 17.958451121123666,
  [422] = 4.965938927208425,
  [423] = 5.714378327842731,
  [424] = 0.04452762333383946,
  [425] = 24.440291186772054,
  [426] = 15.424982896956937,
  [428] = 0.03147642339116238,
  [429] = 13.519081195524036,
  [430] = 30.196723381096746,
  [431] = 21.983680028934426,
  [432] = 17.978326477899117,
  [433] = 0.5000400919213925,
  [434] = 19.07633331229218,
  [435] = 56.600750998459446,
  [436] = 49.74946814227685,
  [439] = 41.4416543120994,
  [440] = 16.355541983065855,
  [441] = 16.626716915208146,
  [442] = 9.68032237316878,
  [443] = 23.64467980203121,
  [444] = 10.852541913118248,
  [445] = 8.810498282871537,
  [446] = 19.082475053441676,
  [447] = 34.014242015309996,
  [448] = 42.073912442655754,
  [449] = 35.19106786112158,
  [450] = 9.126968555991354,
  [451] = 14.631845269067973,
  [452] = 48.27152637621918,
  [453] = 45.075944335352716,
  [454] = 35.371481507388005,
  [455] = 14.483846367757224,
  [456] = 20.791755736130327,
  [457] = 18.705696294312236,
  [458] = 20.84106026924711,
  [459] = 18.438701158230018,
  [460] = 50.01219818033858,
  [462] = 4.559219179975194,
  [463] = 20.805148143914643,
  [464] = 43.559787291031526,
  [465] = 42.46792219778795,
  [466] = 44.496744024171164,
  [467] = 0.028917364578872753,
  [468] = 18.175032798603777,
  [469] = 11.624354050904797,
  [470] = 11.035258712315727,
  [471] = 27.986976096684653,
  [472] = 9.890591705578577,
  [473] = 8.532669797817293,
  [474] = 9.200498845864475,
  [475] = 13.962651389654237,
  [476] = 20.16453042123814,
  [477] = 20.62601402705437,
  [478] = 18.08811010094634,
  [479] = 29.034654774436024,
  [480] = 26.516114393340988,
  [481] = 26.49572722480308,
  [482] = 4.899829907890943,
  [484] = 4.619101156182771,
  [485] = 4.489186270478868,
  [486] = 38.953652032831016,
  [487] = 39.15061425941691,
  [488] = 4.542755901616131,
  [492] = 50.80388567490058,
  [493] = 48.7550178878211,
  [494] = 47.87453105247265,
  [495] = 49.265635422833284,
  [496] = 53.24838395436004,
  [497] = 43.404111213283905,
  [498] = 44.799736587546256,
  [499] = 43.8564675093363,
  [500] = 43.00540985032918,
  [501] = 43.70437411392589,
  [503] = 7.149157301933113,
  [504] = 19.089043304393222,
  [505] = 26.81697440770584,
  [506] = 30.319302298205418,
  [507] = 27.113910531891843,
  [508] = 25.22319257941186,
  [509] = 35.50668511463731,
  [510] = 21.803948798351282,
  [511] = 23.11981683963061,
  [515] = 5.22875426723057,
  [516] = 9.088412069886191,
  [517] = 29.93109307638108,
  [518] = 7.143356768625257,
  [519] = 7.141565427456654,
  [520] = 7.1409683137337865,
  [521] = 50.403563574698076,
  [522] = 52.37838926014198,
  [523] = 33.39059938275501,
  [526] = 10.244509539318233,
  [527] = 10.037396379443592,
  [528] = 11.367509848111329,
  [529] = 11.013080202609217,
  [530] = 8.626672558188732,
  [531] = 13.637906826374683,
  [532] = 0.5297251741439521,
  [533] = 4.854790472794646,
  [534] = 12.268042644156049,
  [535] = 15.540737657232839,
  [536] = 12.371343318212139,
  [537] = 20.49780518055866,
  [538] = 31.635085037524334,
  [539] = 31.81558398575116,
  [540] = 31.646771406100456,
  [541] = 0.01936354501299149,
  [542] = 5.260998408265419,
  [543] = 13.179323487212383,
  [544] = 26.693627772953477,
  [545] = 10.657968141423826,
  [546] = 10.992863637992128,
  [547] = 63.95360938185081,
  [548] = 22.918674816984645,
  [549] = 21.739972328044043,
  [550] = 9.425098907623095,
  [551] = 16.010154345367166,
  [552] = 21.63291836772993,
  [554] = 5.908354985814284,
  [555] = 7.051060047462011,
  [557] = 10.576248863351378,
  [558] = 13.921194636895144,
  [559] = 9.664285604611765,
  [560] = 5.072907585562131,
  [561] = 12.922905794220963,
  [562] = 0.022775623429377653,
  [563] = 0.044783529215068424,
  [564] = 0.06653552911953023,
  [568] = 5.701583033781282,
  [571] = 11.80630313245859,
  [593] = 15.337207179695405,
  [594] = 9.859456490029054,
  [600] = 24.225500850460545,
  [603] = 16.11490515275022,
  [606] = 31.408011218913835,
  [607] = 5.027100432822147,
  [608] = 22.736725735430852,
  [609] = 24.7649504480912,
  [611] = 13.859009507756507,
  [612] = 17.20523481070642,
  [613] = 7.826881377387815,
  [614] = 25.604151134601377,
  [615] = 24.922417867007418,
  [616] = 4.680092057875674,
  [617] = 8.91814935690852,
  [618] = 6.953559906713776,
  [619] = 20.077010609857837,
  [620] = 24.916617333699563,
  [621] = 17.190562873515958,
  [622] = 13.867369099876653,
  [623] = 7.675470397660679,
  [624] = 18.194737551458406,
  [625] = 13.797848002142786,
  [626] = 4.685807289223121,
  [627] = 21.795930414072775,
  [628] = 24.908769553341873,
  [629] = 24.59664968020295,
  [630] = 16.63217624067436,
  [631] = 36.08810327678951,
  [632] = 7.928220106354484,
  [633] = 7.250154823058144,
  [634] = 2.532615204562631,
  [635] = 14.612055214252933,
  [636] = 25.68510269503014,
  [637] = 24.655422730925203,
  [638] = 4.913563523516897,
  [639] = 5.192074424254418,
  [640] = 3.762413567788615,
  [641] = 5.046719883716367,
  [642] = 4.690072387243603,
  [643] = 13.879737884136054,
  [644] = 12.118593609518333,
  [645] = 7.291099764054778,
  [646] = 26.340136449015873,
  [647] = 24.745501601117798,
  [648] = 9.49504651515901,
  [649] = 4.694678693105725,
  [650] = 12.261900903006554,
  [651] = 49.20532693682366,
  [652] = 8.587177750519063,
  [654] = 5.271064039593758,
  [655] = 16.808921902643167,
  [656] = 29.19391353452085,
  [657] = 59.79863619225697,
  [663] = 1.754320117784947,
  [664] = 5.491569607252714,
  [678] = 41.887271753279435,
  [679] = 38.25212871042202,
  [682] = 5.168104573379305,
  [741] = 13.650019704752854,
  [751] = 8.504776056763337,
  [753] = 23.706950233130257,
  [755] = 3.390497020402523,
  [756] = 4.1118956995869675,
  [758] = 10.157842747542023,
  [759] = 0.050498760562515246,
  [760] = 0.02516407832084797,
  [761] = 0.04674547430449046,
  [762] = 66.88629078073473,
  [763] = 25.93589045863452,
  [764] = 24.013098969040506,
  [765] = 9.318727362992256,
  [768] = 18.58900321247183,
  [769] = 13.080032005295546,
  [772] = 37.53328909004987,
  [773] = 7.952445863110826,
  [775] = 4.911516276467066,
  [778] = 13.700859673157009,
  [779] = 25.651834930470372,
  [780] = 88.10813900125052,
  [781] = 23.76572328385251,
  [784] = 5.267822565098191,
  [791] = 4.537296576149913,
  [793] = 6.477574967627906,
  [794] = 6.100881510458874,
  [795] = 6.823474417089053,
  [796] = 6.245383031392827,
  [797] = 28.6288733487673,
  [800] = 9.728176772958596,
  [802] = 9.92232403485097,
  [803] = 6.473565775488653,
  [804] = 7.669925770234052,
  [826] = 48.81362033462253,
  [831] = 6.103696475152392,
  [832] = 7.710273597507818,
  [833] = 25.358310884700753,
  [834] = 14.751779825403947,
  [836] = 3.075732786490899,
  [838] = 15.40954324212279,
  [841] = 3.5634893961133014,
  [842] = 4.25955339305608,
  [843] = 3.6474265251564013,
  [844] = 2.9992169280034395,
  [845] = 17.277229665292168,
  [846] = 8.640832683616734,
  [847] = 12.520536446968624,
  [848] = 0.04640426646285185,
  [849] = 0.034120784163861655,
  [850] = 0.024908172439619007,
  [851] = 0.0299409881037886,
  [852] = 0.03113521554952376,
  [853] = 0.03795937238229609,
  [854] = 7.514079088565613,
  [855] = 17.94446159961648,
  [860] = 14.055545224540351,
  [861] = 12.150581844671954,
  [864] = 13.580413305058578,
  [865] = 17.417977899968097,
  [866] = 16.082575709754963,
  [867] = 14.897134365941998,
  [868] = 16.542865088125456,
  [870] = 10.6524235139972,
  [872] = 11.146833676531553,
  [873] = 3.6961339445503136,
  [874] = 4.31116107910392,
  [875] = 9.286653825878226,
  [876] = 3.3922030596107158,
  [877] = 1.114043602950083,
  [878] = 9.82090000392389,
  [881] = 38.05815205245047,
  [882] = 3.6460616937898465,
  [883] = 32.32389836783229,
  [884] = 12.739250673458978,
  [885] = 18.609902192772193,
  [888] = 14.937226287334536,
  [889] = 8.149919901459175,
  [890] = 8.255097218644279,
  [891] = 8.08944081152873,
  [892] = 13.939193350541583,
  [893] = 13.304887972935393,
  [894] = 13.037466327051128,
  [896] = 18.239094570871426,
  [898] = 14.439062838542155,
  [899] = 12.08012242537358,
  [900] = 3.3940797027397283,
  [901] = 3.7247954032479575,
  [905] = 11.23904509573439,
  [906] = 28.60985101159595,
  [926] = 15.28611130541002,
  [928] = 9.881379093854335,
  [930] = 10.907988187384522,
  [931] = 9.483786656384938,
  [932] = 7.514420296407252,
  [933] = 3.9129715279116546,
  [937] = 0.03181763123280099,
  [939] = 22.207853580890998,
  [941] = 9.970860850324062,
  [942] = 10.269247107837032,
  [943] = 9.321883535527414,
  [944] = 12.201336511115699,
  [945] = 4.350741188733999,
  [946] = 4.988458644756574,
  [947] = 22.421705595638,
  [948] = 0.04120084687786295,
  [949] = 11.654124435087768,
  [954] = 3.819907089104722,
  [955] = 15.704346817298555,
  [956] = 17.579113303181934,
  [958] = 5.985041448222563,
  [959] = 5.97079602083415,
  [960] = 5.9992015736505655,
  [961] = 19.27747533493815,
  [962] = 4.921240699953766,
  [963] = 8.076304309625645,
  [964] = 22.165970318329855,
  [965] = 22.642978880940642,
  [966] = 21.411389176546056,
  [967] = 21.561861834708687,
  [968] = 21.387334023710533,
  [970] = 14.838617221100975,
  [971] = 14.789142084063377,
  [972] = 11.104694508089185,
  [973] = 11.632457737143715,
  [974] = 28.63134710561918,
  [975] = 28.62716730955911,
  [976] = 28.618551811557733,
  [978] = 25.45188713527014,
  [979] = 17.456534386073262,
  [980] = 11.581276560897923,
  [981] = 18.484252405088775,
  [982] = 1.9399371836363544,
  [983] = 11.460574286918263,
  [984] = 11.620174254844725,
  [985] = 11.57718206679826,
  [986] = 24.64535709959686,
  [993] = 7.400712783181183,
  [994] = 11.051210178912331,
  [995] = 14.644043449406555,
  [996] = 17.737348439741844,
  [997] = 18.711582129580503,
  [999] = 30.23971556914321,
  [1006] = 38.10677416988397,
  [1007] = 38.64562665379176,
  [1008] = 35.73486785873313,
  [1009] = 39.8980300365263,
  [1010] = 12.252347083440672,
  [1011] = 9.857409242979221,
  [1012] = 2.6162111257640923,
  [1013] = 9.993807077674258,
  [1015] = 9.728262074919005,
  [1016] = 9.767500976707447,
  [1018] = 4.172374789517413,
  [1019] = 5.876110844779435,
  [1025] = 10.909779528553125,
  [1026] = 3.2952147306249393,
  [1027] = 2.9610016497399143,
  [1028] = 10.541616267425058,
  [1030] = 0.2664833243197595,
  [1031] = 0.09314974076734231,
  [1032] = 0.09187021136119751,
  [1035] = 0.39102418651785453,
  [1038] = 38.35892676485491,
  [1039] = 4.093982287900941,
  [1040] = 8.712315726440025,
  [1042] = 9.577277604993919,
  [1043] = 4.794311382864201,
  [1044] = 38.03401159765454,
  [1045] = 4.967474362495799,
  [1046] = 11.595095478484286,
  [1047] = 11.765528795382776,
  [1048] = 35.831685583798084,
  [1049] = 27.81517794841961,
  [1050] = 4.40251947870266,
  [1051] = 36.47008545550394,
  [1053] = 12.048390096101189,
  [1054] = 25.741999102623378,
  [1057] = 5.331372525603383,
  [1058] = 17.47615383696748,
  [1059] = 3.757295450164036,
  [1060] = 4.007230194164323,
  [1061] = 12.945340209808702,
  [1062] = 3.648876658483365,
  [1063] = 3.646488203591895,
  [1064] = 4.16068842094129,
  [1166] = 13.071331205333761,
  [1167] = 15.505422645623241,
  [1168] = 20.811289885064138,
  [1169] = 12.12166448009308,
  [1172] = 2.329937746629293,
  [1173] = 14.103911436092623,
  [1174] = 13.60916006571663,
  [1175] = 8.329992339883955,
  [1176] = 10.483099122584035,
  [1178] = 8.572505813328602,
  [1179] = 1.3233746137953744,
  [1180] = 19.149266488442436,
  [1182] = 17.739310384831263,
  [1183] = 17.601291812888444,
  [1185] = 18.008693975804952,
  [1190] = 7.350469928499897,
  [1191] = 11.715200638741079,
  [1192] = 0.7513396672882336,
  [1193] = 10.448210620776488,
  [1194] = 5.732291739528758,
  [1195] = 3.5343161256532,
  [1196] = 4.1764692836170765,
  [1197] = 7.016853961337739,
  [1198] = 29.056833284142535,
  [1199] = 17.40467079414419,
  [1200] = 16.21854703464795,
  [1201] = 3.530562839395175,
  [1203] = 16.418665433769,
  [1204] = 12.058114519587889,
  [1205] = 17.682584581158846,
  [1206] = 2.026262767570924,
  [1207] = 1.5641820480318278,
  [1208] = 8.07988699196285,
  [1209] = 12.74616013225216,
  [1210] = 6.515875547851841,
  [1211] = 13.102722326764514,
  [1212] = 7.585732735309723,
  [1213] = 5.133898487255034,
  [1214] = 12.09496496648486,
  [1215] = 12.720398940208444,
  [1216] = 7.842065126340733,
  [1217] = 4.268851306740731,
  [1218] = 6.775278809457599,
  [1219] = 13.627585289165115,
  [1220] = 11.930843994656685,
  [1221] = 8.107183619293938,
  [1222] = 12.88904091593833,
  [1223] = 17.81377899626889,
  [1224] = 55.107028369725995,
  [1225] = 16.927321023691768,
  [1227] = 12.689775536421378,
  [1229] = 3.964579213959495,
  [1230] = 11.787280795287238,
  [1231] = 10.87651176399336,
  [1232] = 5.388268933196623,
  [1237] = 9.078175834637031,
  [1238] = 5.209561326138397,
  [1239] = 42.95832316818305,
  [1240] = 31.98328763991654,
  [1242] = 8.532072684094425,
  [1243] = 11.997635429657445,
  [1245] = 23.978295769193366,
  [1246] = 23.978295769193366,
  [1247] = 3.8769741006187806,
  [1248] = 5.686911096590822,
  [1249] = 8.125694144702834,
  [1250] = 6.193434137503348,
  [1252] = 6.2522071882256,
  [1253] = 33.950777356765215,
  [1254] = 2.23934706467424,
  [1255] = 16.757484820516144,
  [1256] = 16.757484820516144,
  [1257] = 1.9266300778124483,
  [1258] = 5.681878280926652,
  [1259] = 12.942866452956823,
  [1260] = 12.809198280994893,
  [1262] = 4.122217236796536,
  [1265] = 35.17196022198982,
  [1266] = 11.974945108188477,
  [1267] = 11.987740402249925,
  [1282] = 22.422473313281685,
  [1283] = 24.75514072264409,
  [1285] = 11.95174297495705,
  [1286] = 39.2936656470239,
  [1287] = 6.766322103614585,
  [1288] = 10.912509191286235,
  [1289] = 68.92449582276299,
  [1290] = 19.450126502807286,
  [1291] = 25.794374506314902,
  [1292] = 10.801104830991227,
  [1293] = 3.069335139460175,
  [1297] = 5.8551265625186595,
  [1298] = 2.6493935883634476,
  [1299] = 47.26769290611837,
  [1302] = 72.96098458934783,
  [1303] = 56.04117013817211,
  [1304] = 2.9761853986928326,
  [1305] = 20.11300803715071,
  [1306] = 13.288851204378378,
  [1307] = 9.767330372786628,
  [1309] = 19.29410921721803,
  [1310] = 13.569068144324094,
  [1311] = 13.54270983855751,
  [1312] = 9.063503897446571,
  [1313] = 5.427081325183015,
  [1314] = 5.3270221256224914,
  [1315] = 18.257605096280322,
  [1317] = 3.8483126419211366,
  [1318] = 12.160391570119064,
  [1319] = 6.524149838011577,
  [1320] = 11.934000167191842,
  [1321] = 4.901024135336678,
  [1322] = 5.354830564716038,
  [1324] = 9.793176866790752,
  [1326] = 16.348547222312263,
  [1327] = 3.895825833869314,
  [1328] = 4.8436159159809815,
  [1329] = 10.307035876298508,
  [1330] = 12.380044118173924,
  [1332] = 8.15358788575679,
  [1346] = 19.62729867457814,
  [1350] = 19.45720656552129,
  [1351] = 6.6739400804909295,
  [1352] = 8.28657364203544,
  [1354] = 16.194406579852018,
  [1355] = 7.087313380636114,
  [1356] = 5.5506838658166044,
  [1357] = 64.03507275404203,
  [1358] = 4.086134507543252,
  [1359] = 6.241715047095212,
  [1360] = 36.02335908883858,
  [1361] = 20.269622436462836,
  [1362] = 30.489906219024725,
  [1363] = 0.4143969236700998,
  [1364] = 55.067277656175094,
  [1365] = 13.160045244159802,
  [1366] = 1.9936774186944364,
  [1367] = 4.071633174273611,
  [1368] = 44.476356855633256,
  [1369] = 55.8404546253282,
  [1370] = 7.492241786700742,
  [1371] = 3.431186055517928,
  [1372] = 4.194723903144742,
  [1373] = 4.430157313875387,
  [1375] = 14.681746915907622,
  [1376] = 7.552891480552006,
  [1377] = 8.732446989096703,
  [1378] = 13.994980832649496,
  [1379] = 3.5074460081241585,
  [1382] = 1.7869054666614348,
  [1384] = 15.006064969385127,
  [1385] = 52.35851390336653,
  [1387] = 1.459601844569592,
  [1388] = 58.24486098339512,
  [1389] = 2.8333899169670715,
  [1391] = 7.132779325534459,
  [1392] = 7.018133490743884,
  [1393] = 15.33567174440803,
  [1394] = 5.388098329275803,
  [1395] = 9.087303144400865,
  [1396] = 56.85674218164882,
  [1397] = 32.71040155044843,
  [1398] = 14.454758399257532,
  [1399] = 59.6001385303837,
  [1400] = 52.963901916393844,
  [1401] = 2.2338024372476126,
  [1402] = 2.0869977633825982,
  [1404] = 11.461768514363998,
  [1405] = 18.996661281269567,
  [1406] = 11.259688170153526,
  [1407] = 11.15024575494794,
  [1408] = 8.23283340697736,
  [1409] = 4.189093973757705,
  [1410] = 5.111122863825656,
  [1411] = 9.94143167398273,
  [1413] = 8.441737908020603,
  [1414] = 18.85497472502913,
  [1415] = 45.85381291232835,
  [1416] = 16.00725407871324,
  [1417] = 6.16093409058727,
  [1419] = 21.038022495832998,
  [1420] = 5.990330169767962,
  [1421] = 18.185695543654983,
  [1422] = 17.795268470859998,
  [1423] = 18.849174191721275,
  [1424] = 9.171666783246012,
  [1425] = 16.16659814075847,
  [1426] = 3.2214285348705882,
  [1428] = 23.135256494464755,
  [1429] = 6.4402127089684775,
  [1430] = 5.268931490583516,
  [1431] = 5.488157528836328,
  [1433] = 3.1044795471489524,
  [1434] = 8.880360588447044,
  [1436] = 4.301607259538039,
  [1437] = 26.84623298012635,
  [1438] = 11.45878294574966,
  [1439] = 11.47831709468347,
  [1440] = 11.449740937946236,
  [1441] = 2.9012902774531564,
  [1442] = 19.066011775082615,
  [1443] = 4.062847072351417,
  [1444] = 13.443077148799034,
  [1445] = 16.399899002478875,
  [1446] = 19.904530045909514,
  [1448] = 4.88336662953188,
  [1449] = 9.897927674173808,
  [1450] = 14.251313223680507,
  [1451] = 3.820845410669228,
  [1452] = 3.4766520004162738,
  [1454] = 8.548962472255537,
  [1455] = 10.954563057768194,
  [1456] = 24.20204281134789,
  [1458] = 90.60356255107455,
  [1459] = 5.737239253232517,
  [1460] = 4.8984650765243885,
  [1465] = 2.7872415563854487,
  [1466] = 2.974905869286688,
  [1467] = 7.798646428492219,
  [1468] = 12.387380086769154,
  [1469] = 18.10047888520574,
  [1471] = 2.6008567728903547,
  [1474] = 3.288390573792167,
  [1475] = 11.999853280628095,
  [1476] = 13.351292239398246,
  [1477] = 14.032343091308924,
  [1478] = 5.758394139414112,
  [1480] = 0.5639312602682235,
  [1481] = 15.504228418177506,
  [1484] = 61.068270570994265,
  [1485] = 16.335751928250815,
  [1486] = 4.8760306609366495,
  [1487] = 13.15578014613932,
  [1489] = 15.605993656946223,
  [1490] = 55.36591981956929,
  [1491] = 4.421968325676061,
  [1492] = 56.86586949141265,
  [1493] = 13.176252616637635,
  [1494] = 13.055976852460024,
  [1495] = 53.45882389069065,
  [1496] = 12.929900554974555,
  [1497] = 4.185852499262138,
  [1500] = 6.481669461727569,
  [1501] = 9.155971222530637,
  [1502] = 10.507495483261197,
  [1503] = 9.259442500507546,
  [1504] = 4.297853973280014,
  [1505] = 16.572806076229245,
  [1506] = 12.237589844289802,
  [1507] = 8.465537154974896,
  [1508] = 10.978447606682897,
  [1509] = 6.133808067177,
  [1510] = 16.60837699372007,
  [1511] = 13.174375973508623,
  [1513] = 28.410585632078995,
  [1514] = 20.12537682141011,
  [1517] = 4.476049768575781,
  [1520] = 20.555042795993536,
  [1521] = 11.62341572934029,
  [1522] = 15.266406552555392,
  [1523] = 2.699124631282276,
  [1524] = 2.393317103213666,
  [1525] = 4.894541186345545,
  [1526] = 26.177039100712612,
  [1528] = 3.8019936774186944,
  [1529] = 29.337732639771527,
  [1531] = 24.326242465704347,
  [1532] = 1.9966629873087742,
  [1533] = 5.94128154253241,
  [1534] = 4.504967133154654,
  [1535] = 2.6859028274187797,
  [1536] = 1.9680015286111305,
  [1537] = 6.326419893781999,
  [1538] = 3.853430759545716,
  [1539] = 2.065501669359365,
  [1540] = 4.63181114828381,
  [1541] = 5.181838189005259,
  [1542] = 6.776643640824154,
  [1543] = 3.973962429604557,
  [1544] = 21.419748768666203,
  [1545] = 6.041596647974163,
  [1546] = 3.53917833739655,
  [1547] = 2.90538477155282,
  [1549] = 4.971824762476691,
  [1551] = 7.074688690495485,
  [1552] = 17.050923564325355,
  [1553] = 1.0002507877636044,
  [1556] = 54.49848418416352,
  [1563] = 80.4737841485073,
  [1564] = 9.18710643808016,
  [1565] = 11.369386491240341,
  [1566] = 22.436974646551327,
  [1568] = 16.71875773049016,
  [1569] = 21.381874698244314,
  [1570] = 2.9362640812211147,
  [1571] = 2.3942554247781724,
  [1572] = 0.23440978720572955,
  [1573] = 28.98185286094245,
  [1574] = 27.797264536733582,
  [1575] = 34.528442232659394,
  [1576] = 17.43998580575379,
  [1577] = 44.331770032738895,
  [1580] = 6.408309775775267,
  [1581] = 26.689021467091358,
  [1582] = 35.27841706858107,
  [1583] = 2.2743208684421985,
  [1584] = 6.477830873509135,
  [1585] = 9.729029792562693,
  [1586] = 16.00878951400061,
  [1587] = 1.4063734212739678,
  [1588] = 53.989146178557476,
  [1589] = 84.7821302629177,
  [1590] = 81.6754328647981,
  [1591] = 78.5749625097884,
  [1594] = 25.21815976374769,
  [1596] = 32.33669366189374,
  [1597] = 7.56909885302984,
  [1599] = 0.06798566244649434,
  [1600] = 9.032539285817867,
  [1602] = 6.63691902967314,
  [1603] = 12.48479492555698,
  [1612] = 14.841858695596542,
  [1614] = 2.5860995337394845,
  [1615] = 18.17759185741607,
  [1616] = 16.126676823286754,
  [1617] = 10.76280425076729,
  [1618] = 4.032308970524761,
  [1619] = 19.929523520309544,
  [1621] = 3.7394673404384178,
  [1622] = 36.45643714183839,
  [1623] = 5.749863943373146,
  [1626] = 2.9570777595610704,
  [1627] = 2.811211407260562,
  [1629] = 5.97088132279456,
  [1633] = 3.4705102592667783,
  [1634] = 8.992873874227378,
  [1635] = 26.946121575766053,
  [1638] = 5.517416101256839,
  [1639] = 16.046322376580857,
  [1644] = 6.368814968105597,
  [1645] = 9.090203411054793,
  [1651] = 3.2082920329675018,
  [1653] = 12.745307112648064,
  [1654] = 6.500777100859332,
  [1655] = 13.63406823815625,
  [1656] = 5.464528885802854,
  [1657] = 16.656913809193163,
  [1658] = 8.904842251084615,
  [1659] = 16.929880082504056,
  [1660] = 0.15149628168754575,
  [1662] = 9.063503897446571,
  [1664] = 28.751281661955154,
  [1665] = 28.06477148457826,
  [1667] = 28.636209317362532,
  [1668] = 28.397790338017547,
  [1669] = 4.149002052365168,
  [1671] = 13.70811033979183,
  [1672] = 11.512949690609789,
  [1674] = 16.10825159983827,
  [1679] = 38.073762311205435,
  [1681] = 29.67697853632072,
  [1683] = 34.211118939935474,
  [1684] = 40.49539966527511,
  [1685] = 32.337034869735376,
  [1686] = 43.954564763807404,
  [1688] = 3.3585940872093123,
  [1689] = 3.5637453019945307,
  [1692] = 22.772467256842496,
  [1698] = 1.5240901266392903,
  [1699] = 10.404962526848792,
  [1725] = 26.29603533548408,
  [1727] = 3.566986776490097,
  [1729] = 4.193444373738597,
  [1730] = 5.7942209627861665,
  [1732] = 1.2921540962854408,
  [1733] = 5.260145388661322,
  [1734] = 5.283432823853158,
  [1735] = 16.80986022420767,
  [1736] = 7.918836890709422,
  [1737] = 8.360359837789792,
  [1738] = 13.422263470459079,
  [1739] = 0.16693593652169314,
  [1740] = 2.1255542494877617,
  [1741] = 2.1275161945771837,
  [1742] = 18.755256733310244,
  [1744] = 40.65662037044935,
  [1772] = 24.077928458951842,
  [1773] = 25.46519424109405,
  [1774] = 2.795089336743137,
  [1776] = 19.574326157163743,
  [1777] = 20.298710404962527,
  [1778] = 14.037973020695961,
  [1779] = 17.14330558744901,
  [1781] = 14.183498165154832,
  [1782] = 14.293196486241646,
  [1783] = 17.658273522442094,
  [1784] = 23.53873476720242,
  [1785] = 12.835812492642706,
  [1792] = 19.534404839692026,
  [1794] = 8.930944650969968,
  [1795] = 18.523917816679262,
  [1797] = 10.40521843273002,
  [1798] = 27.900224002948036,
  [1799] = 28.505014902252483,
  [1801] = 28.581360156819123,
  [1808] = 23.776556632824537,
  [1809] = 22.06343736191745,
  [1810] = 24.008322059257566,
  [1811] = 22.26108200418662,
  [1812] = 4.258870977372802,
  [1813] = 7.040397302410804,
  [1814] = 5.303222878668198,
  [1815] = 31.81609579751362,
  [1816] = 24.39491054383412,
  [1817] = 24.19214778394037,
  [1818] = 1.3645754606732372,
  [1819] = 1.7476665648729939,
  [1820] = 1.723184902235423,
  [1822] = 0.024908172439619007,
  [1825] = 2.2094060765704517,
  [1830] = 53.345031075504174,
  [1831] = 0.1279529406144812,
  [1833] = 24.28853899920328,
  [1834] = 5.6724097633211805,
  [1835] = 24.46050775138914,
  [1837] = 17.24737397914879,
  [1838] = 22.577722881227256,
  [1839] = 23.235059788144053,
  [1841] = 26.581029185212735,
  [1938] = 16.849610937758573,
  [1939] = 16.863259251424115,
  [1940] = 22.727769029587837,
  [1941] = 5.913729009320092,
  [1942] = 19.715159693800082,
  [1944] = 0.8628293295436515,
  [1949] = 23.61055901786735,
  [1956] = 23.152487490467507,
  [1958] = 2.5977006003551972,
  [1959] = 14.717829645160904,
  [2023] = 5.034777609259016,
  [2035] = 23.466142798893806,
  [2038] = 6.993310620264675,
  [2039] = 15.15312554913137,
  [2055] = 12.29704531069533,
  [2056] = 0.30828128492049006,
  [2057] = 0.26230352825968645,
  [2060] = 5.79336794318207,
  [2063] = 5.478006595547579,
  [2064] = 5.784070029497418,
  [2065] = 3.5606744314197827,
  [2067] = 3.5864356234634984,
  [2068] = 3.7555894109558428,
  [2069] = 5.698597465166944,
  [2070] = 3.756698336441168,
  [2071] = 3.9853075903390414,
  [2072] = 4.953484840988615,
  [2073] = 4.899147492207666,
  [2074] = 4.876286566817878,
  [2075] = 4.782539712327669,
  [2076] = 4.767100057493521,
  [2077] = 4.734514708617033,
  [2078] = 4.888911256958507,
  [2080] = 5.036995460229667,
  [2081] = 4.218693754019855,
  [2083] = 4.2783198243462035,
  [2084] = 4.0014296608564655,
  [2085] = 4.648445030563693,
  [2086] = 4.4026047806630695,
  [2087] = 5.056359005242658,
  [2088] = 4.884390253056796,
  [2089] = 4.772644684920149,
  [2090] = 10.012914716806021,
  [2091] = 10.122101226130379,
  [2114] = 1.9803703128705303,
  [2118] = 3.839014728236484,
  [2142] = 14.413557552379668,
  [2143] = 5.729903284637287,
  [2152] = 7.443534367306829,
} end
