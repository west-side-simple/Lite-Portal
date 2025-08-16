
local currentskin = m_simpleTV.Config.GetValue('skin/path','simpleTVConfig')
local pass = m_simpleTV.Common.GetMainPath(2) .. currentskin:gsub('^%./','')
local file = io.open(pass .. '/img/back.svg', 'r')
if not file then
	return
end

local answer = file:read('*a')
file:close()

local color = {
{'Blue', 'B0C4DE', '1E213D', '4169E1', '6699CC', '252850'},
{'Green', 'A0D6B4', '123524', '00A693', '71BC78', '177245'},
{'Red', 'FFCBBB', '560319', 'FF2400', 'FFA089', '92000A'},
{'Orange', 'E7C697', '35170C', 'E8793E', 'DEAA88', '4D220E'},
{'Magenta', 'FCB4D5', '270A1F', 'ED3CCA', 'FF97BB', '4A192C'},
{'Cyan', 'AFEEEE', '193737', '48D1CC', '78DBE2', '256D7B'},
{'Orchid', 'C9A0DC', '320B35', '9932CC', 'BA55D3', '7442C8'},
{'User', 'C1CACA', '293133', '708090', '9DA1AA', '414A4C'},
}

local k = 1

if answer:match('Blue') then
	k = 1
elseif answer:match('Green') then
	k = 2
elseif answer:match('Red') then
	k = 3
elseif answer:match('Orange') then
	k = 4
elseif answer:match('Magenta') then
	k = 5
elseif answer:match('Cyan') then
	k = 6
elseif answer:match('Orchid') then
	k = 7
elseif answer:match('User') then
	k = 8	
end

local title_color, color_light, color_black, color_base, color_light1, color_black1 = color[k][1], color[k][2], color[k][3], color[k][4], color[k][5], color[k][6]

local color_for_ui, color_mono, color_mono_filter, gradient, gradient_activ, color_mono_invers, color_mono_back, color_mono_hex

local i = 1
if answer:match('WS Light') then
	i = 1
	color_for_ui = color_black1
	color_mono = '222'
	color_mono_hex = 'C0C0C0'
	color_mono_filter = '2F353B'
	color_mono_invers = 'FFFFFF'
	color_mono_back = '707070'
	gradient = {color_base, color_black1}
	gradient_activ = {color_light1, color_base}
elseif answer:match('WS Black') then
	i = 2
	color_for_ui = color_light1
	color_mono = '32'
	color_mono_hex = '2F353B'
	color_mono_filter = 'C0C0C0'
	color_mono_invers = '000000'
	color_mono_back = 'CFCFCF'
	gradient = {color_light, color_base}
	gradient_activ = {color_base, color_base}
end

local t = {
{ [[
<svg version="1.0" xmlns="http://www.w3.org/2000/svg"
 width="905.000000pt" height="1280.000000pt" viewBox="0 0 905.000000 1280.000000"
 preserveAspectRatio="xMidYMid meet">
<metadata>
WS Black ]] .. title_color ..
[[</metadata>
<g transform="translate(0.000000,1280.000000) scale(0.100000,-0.100000)"
fill="#]] .. color_black .. [[" stroke="none">
<path d="M0 6220 l0 -6130 4525 0 4525 0 0 6130 0 6130 -4525 0 -4525 0 0
-6130z"/>
</g>
</svg>
]],
[[
<svg version="1.0" xmlns="http://www.w3.org/2000/svg"
 width="905.000000pt" height="1280.000000pt" viewBox="0 0 905.000000 1280.000000"
 preserveAspectRatio="xMidYMid meet">
<metadata>WS Back</metadata>
<g transform="translate(0.000000,1280.000000) scale(0.100000,-0.100000)"
fill="#]] .. color_base .. [[" stroke="none">
<path d="M0 6220 l0 -6130 4525 0 4525 0 0 6130 0 6130 -4525 0 -4525 0 0
-6130z"/>
</g>
</svg>
]],
[[
<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" width="625px" height="208px" version="1.1" style="shape-rendering:geometricPrecision; text-rendering:geometricPrecision; image-rendering:optimizeQuality; fill-rule:evenodd; clip-rule:evenodd"
viewBox="0 0 399.86 133.29"
 xmlns:xlink="http://www.w3.org/1999/xlink"
 xmlns:xodm="http://www.corel.com/coreldraw/odm/2003">
 <defs>
  <style type="text/css">
   <!\[CDATA\[
    .fil1 {fill:none}
    .fil0 {fill:none}
    .fil10 {fill:white;fill-opacity:0.050980}
    .fil2 {fill:#99FFFF;fill-opacity:0.101961}
    .fil6 {fill:white;fill-opacity:0.101961}
    .fil7 {fill:white;fill-opacity:0.129412}
    .fil8 {fill:white;fill-opacity:0.149020}
    .fil3 {fill:#99FFFF;fill-opacity:0.180392}
    .fil4 {fill:#99FFFF;fill-opacity:0.250980}
    .fil9 {fill:url(#id0)}
    .fil11 {fill:url(#id1)}
    .fil5 {fill:url(#id2)}
   \]\]>
  </style>
  <linearGradient id="id0" gradientUnits="userSpaceOnUse" x1="62.61" y1="111.85" x2="63.41" y2="19.04">
   <stop offset="0" style="stop-opacity:1; stop-color:#BCBCBC"/>
   <stop offset="1" style="stop-opacity:1; stop-color:#ECECEC"/>
  </linearGradient>
  <linearGradient id="id1" gradientUnits="userSpaceOnUse" xlink:href="#id0" x1="33.98" y1="96.29" x2="34.32" y2="48.33">
  </linearGradient>
  <linearGradient id="id2" gradientUnits="objectBoundingBox" x1="45.8586%" y1="97.482%" x2="45.1993%" y2="0.0023761%">
   <stop offset="0" style="stop-opacity:1; stop-color:#035F86"/>
   <stop offset="1" style="stop-opacity:1; stop-color:#5BCAFD"/>
  </linearGradient>
 </defs>
 <g id="Layer_x0020_1">
  <metadata id="CorelCorpID_0Corel-Layer"/>
  <polygon class="fil0" points="0,0 133.29,0 133.29,133.29 0,133.29 "/>
  <rect class="fil1" x="133.29" width="133.29" height="133.29"/>
  <rect class="fil1" x="266.57" width="133.29" height="133.29"/>
  <path class="fil2" d="M236.88 29.79c5.59,0.2 10.87,2.06 13.96,7.17 3.27,5.39 2.17,11.14 -0.49,16.23 4.66,2.84 8.24,6.94 8.5,12.76 0.3,6.43 -3.53,11.01 -8.53,14.26 2.62,4.95 3.65,10.44 0.78,15.67 -3.03,5.51 -8.51,7.47 -14.32,7.71 -0.21,5.62 -2.09,10.92 -7.23,14 -5.39,3.23 -11.11,2.13 -16.17,-0.52 -2.86,4.67 -6.99,8.26 -12.83,8.5 -6.41,0.27 -10.97,-3.56 -14.19,-8.54 -4.97,2.62 -10.5,3.65 -15.74,0.74 -5.47,-3.04 -7.41,-8.5 -7.64,-14.28 -5.64,-0.23 -10.97,-2.12 -14.04,-7.3 -3.19,-5.38 -2.09,-11.07 0.57,-16.1 -4.69,-2.89 -8.29,-7.04 -8.51,-12.91 -0.24,-6.38 3.57,-10.91 8.54,-14.11 -2.62,-5 -3.64,-10.56 -0.7,-15.81 3.06,-5.43 8.49,-7.35 14.24,-7.57 0.24,-5.67 2.16,-11.02 7.37,-14.08 5.38,-3.15 11.04,-2.04 16.04,0.61 3.08,-4.82 7.45,-8.51 13.54,-8.52 6.17,0 10.47,3.71 13.48,8.55 4.91,-2.62 10.38,-3.65 15.59,-0.81 5.55,3.01 7.52,8.52 7.78,14.35z"/>
  <path class="fil2" d="M370.16 29.79c5.6,0.2 10.88,2.06 13.97,7.17 3.26,5.39 2.17,11.14 -0.49,16.23 4.65,2.84 8.23,6.94 8.5,12.76 0.3,6.43 -3.53,11.01 -8.53,14.26 2.62,4.95 3.65,10.44 0.78,15.67 -3.03,5.51 -8.51,7.47 -14.32,7.71 -0.22,5.62 -2.09,10.92 -7.23,14 -5.39,3.23 -11.11,2.13 -16.17,-0.52 -2.86,4.67 -6.99,8.26 -12.84,8.5 -6.4,0.27 -10.96,-3.56 -14.19,-8.54 -4.97,2.62 -10.49,3.65 -15.73,0.74 -5.47,-3.04 -7.41,-8.5 -7.64,-14.28 -5.65,-0.23 -10.97,-2.12 -14.04,-7.3 -3.19,-5.38 -2.09,-11.07 0.56,-16.1 -4.68,-2.89 -8.29,-7.04 -8.5,-12.91 -0.24,-6.38 3.57,-10.91 8.54,-14.11 -2.62,-5 -3.65,-10.56 -0.7,-15.81 3.05,-5.43 8.48,-7.35 14.24,-7.57 0.24,-5.67 2.15,-11.02 7.37,-14.08 5.38,-3.15 11.04,-2.04 16.04,0.61 3.08,-4.82 7.45,-8.51 13.54,-8.52 6.17,0 10.47,3.71 13.47,8.55 4.92,-2.62 10.38,-3.65 15.6,-0.81 5.55,3.01 7.52,8.52 7.77,14.35z"/>
  <path class="fil3" d="M233.03 33.68c5.71,-0.53 11.64,0.38 14.58,5.23 3.19,5.28 0.61,11.19 -2.58,15.76 5.16,2.27 9.79,5.87 10.05,11.45 0.28,6.04 -4.66,10.1 -10.02,12.75 3.29,4.66 5.45,10.23 2.73,15.19 -2.87,5.21 -9.02,6.15 -14.89,5.68 0.52,5.72 -0.4,11.68 -5.29,14.61 -5.28,3.16 -11.15,0.58 -15.7,-2.61 -2.28,5.17 -5.91,9.82 -11.52,10.05 -6.02,0.25 -10.05,-4.66 -12.67,-10.02 -4.69,3.29 -10.29,5.46 -15.26,2.7 -5.18,-2.88 -6.11,-9 -5.61,-14.85 -5.75,0.5 -11.74,-0.43 -14.66,-5.36 -3.12,-5.27 -0.54,-11.1 2.65,-15.62 -5.19,-2.31 -9.85,-5.97 -10.06,-11.6 -0.22,-6 4.67,-10 10.02,-12.6 -3.29,-4.71 -5.46,-10.35 -2.66,-15.32 2.89,-5.15 8.98,-6.06 14.81,-5.55 -0.49,-5.77 0.46,-11.79 5.41,-14.7 5.26,-3.08 11.02,-0.54 15.52,2.65 2.49,-5.26 6.37,-10.04 12.15,-10.04 5.86,0 9.64,4.81 12.05,10.1 4.66,-3.33 10.23,-5.53 15.22,-2.82 5.23,2.85 6.2,9.03 5.73,14.92z"/>
  <path class="fil3" d="M366.32 33.68c5.7,-0.53 11.63,0.38 14.57,5.23 3.2,5.28 0.61,11.19 -2.57,15.76 5.16,2.27 9.79,5.87 10.05,11.45 0.28,6.04 -4.66,10.1 -10.03,12.75 3.3,4.66 5.46,10.23 2.73,15.19 -2.86,5.21 -9.01,6.15 -14.88,5.68 0.52,5.72 -0.41,11.68 -5.3,14.61 -5.27,3.16 -11.14,0.58 -15.69,-2.61 -2.29,5.17 -5.92,9.82 -11.52,10.05 -6.02,0.25 -10.05,-4.66 -12.67,-10.02 -4.69,3.29 -10.3,5.46 -15.26,2.7 -5.18,-2.88 -6.11,-9 -5.62,-14.85 -5.74,0.5 -11.73,-0.43 -14.65,-5.36 -3.12,-5.27 -0.55,-11.1 2.65,-15.62 -5.19,-2.31 -9.86,-5.97 -10.07,-11.6 -0.22,-6 4.68,-10 10.03,-12.6 -3.3,-4.71 -5.46,-10.35 -2.67,-15.32 2.89,-5.15 8.99,-6.06 14.81,-5.55 -0.49,-5.77 0.47,-11.79 5.42,-14.7 5.26,-3.08 11.02,-0.54 15.52,2.65 2.49,-5.26 6.37,-10.04 12.15,-10.04 5.86,0 9.64,4.81 12.05,10.1 4.65,-3.33 10.23,-5.53 15.21,-2.82 5.24,2.85 6.2,9.03 5.74,14.92z"/>
  <path class="fil4" d="M228.57 38.24c5.35,-1.22 13.04,-1.94 15.8,2.63 2.91,4.8 -1.9,11.49 -5.57,15.59 5.28,1.51 12.26,4.54 12.51,9.83 0.25,5.61 -7.18,9.2 -12.37,11.05 3.72,4.03 8.09,10.26 5.54,14.9 -2.68,4.86 -10.73,4.12 -16.12,3.01 1.2,5.37 1.9,13.1 -2.69,15.86 -4.8,2.87 -11.44,-1.93 -15.53,-5.61 -1.52,5.28 -4.59,12.3 -9.91,12.52 -5.59,0.23 -9.13,-7.17 -10.96,-12.36 -4.05,3.7 -10.33,8.09 -14.98,5.5 -4.83,-2.68 -4.07,-10.69 -2.95,-16.07 -5.37,1.18 -13.16,1.87 -15.9,-2.75 -2.84,-4.79 1.94,-11.38 5.64,-15.46 -5.27,-1.54 -12.33,-4.65 -12.53,-9.98 -0.2,-5.57 7.16,-9.08 12.36,-10.89 -3.7,-4.07 -8.09,-10.39 -5.48,-15.04 2.7,-4.81 10.65,-4.03 16.03,-2.9 -1.16,-5.37 -1.84,-13.21 2.81,-15.94 4.73,-2.77 11.17,1.85 15.25,5.54 1.7,-5.24 5.09,-12.41 10.51,-12.41 5.53,0 8.75,7.35 10.39,12.6 4,-3.77 10.34,-8.36 15.07,-5.78 4.89,2.66 4.16,10.76 3.08,16.16z"/>
  <path class="fil4" d="M361.85 38.24c5.36,-1.22 13.05,-1.94 15.81,2.63 2.9,4.8 -1.9,11.49 -5.57,15.59 5.28,1.51 12.26,4.54 12.5,9.83 0.26,5.61 -7.18,9.2 -12.36,11.05 3.71,4.03 8.08,10.26 5.53,14.9 -2.67,4.86 -10.73,4.12 -16.12,3.01 1.21,5.37 1.91,13.1 -2.69,15.86 -4.79,2.87 -11.43,-1.93 -15.53,-5.61 -1.51,5.28 -4.58,12.3 -9.9,12.52 -5.59,0.23 -9.13,-7.17 -10.97,-12.36 -4.04,3.7 -10.32,8.09 -14.97,5.5 -4.83,-2.68 -4.07,-10.69 -2.95,-16.07 -5.37,1.18 -13.16,1.87 -15.9,-2.75 -2.84,-4.79 1.94,-11.38 5.64,-15.46 -5.28,-1.54 -12.33,-4.65 -12.53,-9.98 -0.21,-5.57 7.16,-9.08 12.36,-10.89 -3.7,-4.07 -8.09,-10.39 -5.48,-15.04 2.7,-4.81 10.65,-4.03 16.03,-2.9 -1.17,-5.37 -1.84,-13.21 2.81,-15.94 4.73,-2.77 11.17,1.85 15.25,5.54 1.7,-5.24 5.09,-12.41 10.51,-12.41 5.52,0 8.75,7.35 10.39,12.6 4,-3.77 10.34,-8.36 15.07,-5.78 4.89,2.66 4.16,10.76 3.07,16.16z"/>
  <path class="fil5" d="M199.93 33.23c-18.45,0 -33.42,14.96 -33.42,33.41 0,18.46 14.97,33.42 33.42,33.42 18.46,0 33.42,-14.96 33.42,-33.42 0,-18.45 -14.96,-33.41 -33.42,-33.41zm-23.74 -7.84c2.94,-1.73 9.28,3.53 12.38,6.59 -2.33,0.78 -4.62,1.81 -6.82,3.1 -2.21,1.29 -4.22,2.79 -6.04,4.44 -1.16,-4.2 -2.47,-12.4 0.48,-14.13zm23.84 -6.35c3.42,0 6.23,7.74 7.36,11.95 -2.41,-0.51 -4.9,-0.78 -7.46,-0.78 -2.56,0 -5.05,0.27 -7.46,0.78 1.13,-4.21 4.15,-11.95 7.56,-11.95zm-41.3 23.78c1.67,-2.98 9.79,-1.64 14.01,-0.56 -1.62,1.85 -3.07,3.89 -4.33,6.12 -1.25,2.23 -2.24,4.53 -2.97,6.88 -3.12,-3.05 -8.39,-9.46 -6.71,-12.44zm-6.4 23.94c-0.13,-3.41 7.5,-6.51 11.67,-7.79 -0.42,2.43 -0.6,4.93 -0.5,7.48 0.09,2.56 0.45,5.04 1.05,7.43 -4.25,-0.97 -12.09,-3.7 -12.22,-7.12zm6.36 23.65c-1.74,-2.94 3.48,-9.3 6.53,-12.42 0.79,2.33 1.83,4.62 3.14,6.82 1.3,2.2 2.8,4.2 4.46,6.02 -4.19,1.17 -12.39,2.52 -14.13,-0.42zm17.44 17.45c-2.99,-1.66 -1.69,-9.79 -0.63,-14.01 1.86,1.61 3.91,3.06 6.15,4.3 2.23,1.24 4.54,2.22 6.89,2.94 -3.03,3.14 -9.42,8.43 -12.41,6.77zm23.95 6.38c-3.42,0.15 -6.55,-7.47 -7.85,-11.63 2.43,0.41 4.93,0.57 7.49,0.47 2.55,-0.11 5.03,-0.48 7.42,-1.08 -0.96,4.25 -3.65,12.1 -7.06,12.24zm23.64 -6.37c-2.93,1.75 -9.31,-3.44 -12.44,-6.47 2.32,-0.8 4.6,-1.86 6.79,-3.17 2.2,-1.31 4.2,-2.82 6,-4.5 1.2,4.2 2.58,12.38 -0.35,14.14zm17.44 -17.45c-1.64,2.99 -9.78,1.73 -14.01,0.69 1.61,-1.86 3.04,-3.92 4.27,-6.16 1.24,-2.24 2.2,-4.56 2.92,-6.91 3.14,3.02 8.47,9.39 6.82,12.38zm6.37 -23.95c0.16,3.41 -7.44,6.58 -11.59,7.9 0.39,-2.43 0.54,-4.93 0.43,-7.49 -0.12,-2.55 -0.5,-5.03 -1.12,-7.41 4.26,0.93 12.12,3.59 12.28,7zm-6.39 -23.64c1.77,2.92 -3.39,9.33 -6.41,12.47 -0.81,-2.32 -1.87,-4.59 -3.2,-6.78 -1.32,-2.19 -2.84,-4.18 -4.52,-5.98 4.18,-1.21 12.36,-2.64 14.13,0.29zm-17.45 -17.43c3,1.63 1.77,9.77 0.75,14.01 -1.87,-1.6 -3.94,-3.03 -6.18,-4.25 -2.25,-1.22 -4.57,-2.18 -6.92,-2.88 3,-3.16 9.34,-8.52 12.35,-6.88z"/>
  <path class="fil5" d="M333.22 33.23c-18.46,0 -33.42,14.96 -33.42,33.41 0,18.46 14.96,33.42 33.42,33.42 18.45,0 33.41,-14.96 33.41,-33.42 0,-18.45 -14.96,-33.41 -33.41,-33.41zm-23.75 -7.84c2.95,-1.73 9.29,3.53 12.39,6.59 -2.33,0.78 -4.62,1.81 -6.82,3.1 -2.21,1.29 -4.23,2.79 -6.05,4.44 -1.15,-4.2 -2.46,-12.4 0.48,-14.13zm23.85 -6.35c3.42,0 6.23,7.74 7.36,11.95 -2.41,-0.51 -4.9,-0.78 -7.46,-0.78 -2.56,0 -5.05,0.27 -7.46,0.78 1.13,-4.21 4.14,-11.95 7.56,-11.95zm-41.31 23.78c1.68,-2.98 9.8,-1.64 14.02,-0.56 -1.62,1.85 -3.07,3.89 -4.33,6.12 -1.25,2.23 -2.24,4.53 -2.97,6.88 -3.12,-3.05 -8.39,-9.46 -6.72,-12.44zm-6.39 23.94c-0.13,-3.41 7.5,-6.51 11.66,-7.79 -0.41,2.43 -0.59,4.93 -0.5,7.48 0.1,2.56 0.46,5.04 1.05,7.43 -4.25,-0.97 -12.09,-3.7 -12.21,-7.12zm6.36 23.65c-1.74,-2.94 3.48,-9.3 6.53,-12.42 0.79,2.33 1.83,4.62 3.13,6.82 1.31,2.2 2.81,4.2 4.47,6.02 -4.2,1.17 -12.39,2.52 -14.13,-0.42zm17.44 17.45c-2.99,-1.66 -1.69,-9.79 -0.63,-14.01 1.86,1.61 3.91,3.06 6.14,4.3 2.24,1.24 4.55,2.22 6.9,2.94 -3.03,3.14 -9.43,8.43 -12.41,6.77zm23.95 6.38c-3.42,0.15 -6.55,-7.47 -7.85,-11.63 2.43,0.41 4.93,0.57 7.48,0.47 2.56,-0.11 5.04,-0.48 7.42,-1.08 -0.95,4.25 -3.64,12.1 -7.05,12.24zm23.64 -6.37c-2.93,1.75 -9.32,-3.44 -12.45,-6.47 2.33,-0.8 4.61,-1.86 6.8,-3.17 2.19,-1.31 4.2,-2.82 6,-4.5 1.2,4.2 2.58,12.38 -0.35,14.14zm17.44 -17.45c-1.64,2.99 -9.78,1.73 -14.01,0.69 1.6,-1.86 3.04,-3.92 4.27,-6.16 1.23,-2.24 2.2,-4.56 2.92,-6.91 3.14,3.02 8.47,9.39 6.82,12.38zm6.37 -23.95c0.16,3.41 -7.45,6.58 -11.6,7.9 0.4,-2.43 0.55,-4.93 0.43,-7.49 -0.11,-2.55 -0.49,-5.03 -1.11,-7.41 4.26,0.93 12.12,3.59 12.28,7zm-6.39 -23.64c1.77,2.92 -3.4,9.33 -6.41,12.47 -0.82,-2.32 -1.88,-4.59 -3.2,-6.78 -1.33,-2.19 -2.85,-4.18 -4.52,-5.98 4.18,-1.21 12.36,-2.64 14.13,0.29zm-17.46 -17.43c3,1.63 1.78,9.77 0.76,14.01 -1.88,-1.6 -3.94,-3.03 -6.18,-4.25 -2.25,-1.22 -4.57,-2.18 -6.93,-2.88 3.01,-3.16 9.35,-8.52 12.35,-6.88z"/>
  <g id="_2206884426512">
   <g>
    <path class="fil6" d="M7.7 66.64c0,-32.54 26.4,-58.94 58.94,-58.94 32.55,0 58.94,26.4 58.94,58.94 0,32.55 -26.39,58.94 -58.94,58.94 -32.54,0 -58.94,-26.39 -58.94,-58.94z"/>
    <path class="fil7" d="M10.85 66.64c0,-30.81 24.98,-55.79 55.79,-55.79 30.82,0 55.8,24.98 55.8,55.79 0,30.82 -24.98,55.8 -55.8,55.8 -30.81,0 -55.79,-24.98 -55.79,-55.8z"/>
    <path class="fil8" d="M15.3 66.64c0,-28.35 22.99,-51.34 51.34,-51.34 28.36,0 51.35,22.99 51.35,51.34 0,28.36 -22.99,51.35 -51.35,51.35 -28.35,0 -51.34,-22.99 -51.34,-51.35z"/>
   </g>
   <g>
    <path class="fil1" d="M66.64 19.04c-26.29,0 -47.6,21.31 -47.6,47.6 0,26.29 21.31,47.61 47.6,47.61 26.29,0 47.61,-21.32 47.61,-47.61 0,-26.29 -21.32,-47.6 -47.61,-47.6z"/>
    <path class="fil9" d="M66.64 19.04c-3.22,0 -6.37,0.32 -9.41,0.93 17.62,4.37 30.89,23.61 30.89,46.67 0,23.07 -13.27,42.3 -30.89,46.67 3.04,0.62 6.19,0.94 9.41,0.94 26.29,0 47.61,-21.32 47.61,-47.61 0,-26.29 -21.32,-47.6 -47.61,-47.6z"/>
    <path class="fil10" d="M57.23 19.97c-21.78,4.37 -38.19,23.61 -38.19,46.67 0,23.07 16.41,42.3 38.19,46.67 17.62,-4.37 30.89,-23.6 30.89,-46.67 0,-23.06 -13.27,-42.3 -30.89,-46.67z"/>
    <path class="fil11" d="M52.87 74.58c0.17,-1.87 2.99,-1.88 3.27,0 0.76,5.01 4.22,8.39 9.22,9.21 1.73,0.28 1.69,3.1 0,3.28 -5.04,0.52 -8.52,4.19 -9.22,9.21 -0.23,1.65 -3.04,1.67 -3.27,0 -0.69,-5.02 -4.19,-8.55 -9.22,-9.21 -1.73,-0.23 -1.8,-3.05 0,-3.28 5.03,-0.64 8.74,-4.17 9.22,-9.21zm-15.73 -25.36c0.11,-1.19 1.89,-1.19 2.07,0 0.47,3.16 2.66,5.3 5.82,5.82 1.1,0.18 1.07,1.96 0,2.07 -3.18,0.33 -5.38,2.65 -5.82,5.82 -0.15,1.04 -1.93,1.05 -2.07,0 -0.44,-3.17 -2.65,-5.4 -5.82,-5.82 -1.1,-0.15 -1.14,-1.93 0,-2.07 3.17,-0.41 5.52,-2.64 5.82,-5.82z"/>
   </g>
  </g>
 </g>
</svg>
]],
[[
<svg version="1.0" xmlns="http://www.w3.org/2000/svg"
 width="905.000000pt" height="1280.000000pt" viewBox="0 0 905.000000 1280.000000"
 preserveAspectRatio="xMidYMid meet">
<metadata>
WS Black1 ]] .. title_color ..
[[</metadata>
<g transform="translate(0.000000,1280.000000) scale(0.100000,-0.100000)"
fill="#]] .. color_black1 .. [[" stroke="none">
<path d="M0 6220 l0 -6130 4525 0 4525 0 0 6130 0 6130 -4525 0 -4525 0 0
-6130z"/>
</g>
</svg>
]],
[[
<svg width="90" height="30" version="1.1" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="1" width="30" height="29" fill="#]] .. color_black .. [["/>
  <rect x="30" y="1" width="30" height="29" fill="#]] .. color_base .. [[" fill-opacity="0.3"/>
  <rect x="60" y="1" width="30" height="29" fill="#]] .. color_base .. [[" fill-opacity="0.3"/>
</svg>
]],
},
{ [[
<svg version="1.0" xmlns="http://www.w3.org/2000/svg"
 width="905.000000pt" height="1280.000000pt" viewBox="0 0 905.000000 1280.000000"
 preserveAspectRatio="xMidYMid meet">
<metadata>
WS Light ]] .. title_color ..
[[</metadata>
<g transform="translate(0.000000,1280.000000) scale(0.100000,-0.100000)"
fill="#]] .. color_light .. [[" stroke="none">
<path d="M0 6220 l0 -6130 4525 0 4525 0 0 6130 0 6130 -4525 0 -4525 0 0
-6130z"/>
</g>
</svg>
]],
[[
<svg version="1.0" xmlns="http://www.w3.org/2000/svg"
 width="905.000000pt" height="1280.000000pt" viewBox="0 0 905.000000 1280.000000"
 preserveAspectRatio="xMidYMid meet">
<metadata>WS Back</metadata>
<g transform="translate(0.000000,1280.000000) scale(0.100000,-0.100000)"
fill="#]] .. color_base .. [[" stroke="none">
<path d="M0 6220 l0 -6130 4525 0 4525 0 0 6130 0 6130 -4525 0 -4525 0 0
-6130z"/>
</g>
</svg>
]],
[[
<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" width="625px" height="208px" version="1.1" style="shape-rendering:geometricPrecision; text-rendering:geometricPrecision; image-rendering:optimizeQuality; fill-rule:evenodd; clip-rule:evenodd"
viewBox="0 0 166.34 55.45"
 xmlns:xlink="http://www.w3.org/1999/xlink"
 xmlns:xodm="http://www.corel.com/coreldraw/odm/2003">
 <defs>
  <style type="text/css">
   <!\[CDATA\[
    .fil5 {fill:none}
    .fil4 {fill:none}
    .fil10 {fill:#99FFFF;fill-opacity:0.050980}
    .fil12 {fill:white;fill-opacity:0.050980}
    .fil6 {fill:#99FFFF;fill-opacity:0.101961}
    .fil0 {fill:white;fill-opacity:0.101961}
    .fil7 {fill:#99FFFF;fill-opacity:0.129412}
    .fil8 {fill:#99FFFF;fill-opacity:0.149020}
    .fil1 {fill:white;fill-opacity:0.180392}
    .fil2 {fill:white;fill-opacity:0.250980}
    .fil3 {fill:url(#id0)}
    .fil9 {fill:url(#id1)}
    .fil11 {fill:url(#id2)}
   \]\]>
  </style>
  <linearGradient id="id0" gradientUnits="userSpaceOnUse" x1="27.79" y1="41.62" x2="27.66" y2="13.82">
   <stop offset="0" style="stop-opacity:1; stop-color:#BCBCBC"/>
   <stop offset="1" style="stop-opacity:1; stop-color:#ECECEC"/>
  </linearGradient>
  <linearGradient id="id1" gradientUnits="objectBoundingBox" x1="46.4481%" y1="97.4784%" x2="44.61%" y2="0.00617498%">
   <stop offset="0" style="stop-opacity:1; stop-color:#035F86"/>
   <stop offset="1" style="stop-opacity:1; stop-color:#5BCAFD"/>
  </linearGradient>
  <linearGradient id="id2" gradientUnits="objectBoundingBox" xlink:href="#id1" x1="46.1396%" y1="97.4801%" x2="44.9195%" y2="0.00434075%">
  </linearGradient>
 </defs>
 <g id="Layer_x0020_1">
  <metadata id="CorelCorpID_0Corel-Layer"/>
  <g id="_2206476373904">
   <path class="fil0" d="M43.09 12.39c2.33,0.09 4.53,0.86 5.81,2.98 1.36,2.25 0.91,4.64 -0.2,6.76 1.94,1.18 3.43,2.88 3.54,5.3 0.12,2.68 -1.47,4.59 -3.55,5.94 1.09,2.06 1.51,4.34 0.32,6.52 -1.26,2.29 -3.54,3.1 -5.96,3.2 -0.09,2.34 -0.87,4.55 -3,5.83 -2.25,1.34 -4.63,0.88 -6.73,-0.22 -1.19,1.94 -2.91,3.44 -5.34,3.54 -2.66,0.11 -4.56,-1.48 -5.9,-3.56 -2.07,1.1 -4.37,1.52 -6.55,0.31 -2.28,-1.26 -3.08,-3.53 -3.18,-5.94 -2.35,-0.09 -4.56,-0.88 -5.84,-3.03 -1.33,-2.24 -0.87,-4.61 0.24,-6.7 -1.95,-1.2 -3.45,-2.93 -3.54,-5.37 -0.1,-2.66 1.49,-4.54 3.55,-5.87 -1.09,-2.08 -1.52,-4.4 -0.29,-6.58 1.27,-2.26 3.53,-3.06 5.93,-3.15 0.1,-2.36 0.89,-4.58 3.06,-5.86 2.24,-1.31 4.59,-0.85 6.67,0.26 1.28,-2.01 3.1,-3.54 5.64,-3.55 2.56,0 4.35,1.55 5.6,3.56 2.05,-1.09 4.32,-1.52 6.49,-0.34 2.31,1.26 3.13,3.55 3.23,5.97z"/>
   <path class="fil1" d="M41.49 14.01c2.38,-0.22 4.84,0.16 6.07,2.18 1.33,2.19 0.25,4.65 -1.07,6.55 2.14,0.95 4.07,2.44 4.18,4.77 0.11,2.51 -1.94,4.2 -4.17,5.3 1.37,1.94 2.27,4.26 1.13,6.32 -1.19,2.17 -3.75,2.56 -6.19,2.36 0.21,2.38 -0.17,4.86 -2.2,6.08 -2.2,1.31 -4.64,0.24 -6.53,-1.09 -0.95,2.16 -2.46,4.09 -4.79,4.19 -2.51,0.1 -4.18,-1.94 -5.28,-4.17 -1.95,1.37 -4.28,2.27 -6.34,1.12 -2.16,-1.2 -2.54,-3.75 -2.34,-6.18 -2.39,0.21 -4.88,-0.18 -6.1,-2.23 -1.3,-2.19 -0.22,-4.61 1.11,-6.5 -2.16,-0.96 -4.1,-2.48 -4.19,-4.82 -0.09,-2.5 1.95,-4.16 4.17,-5.24 -1.37,-1.96 -2.27,-4.31 -1.11,-6.38 1.2,-2.14 3.74,-2.52 6.16,-2.31 -0.2,-2.4 0.19,-4.9 2.26,-6.11 2.18,-1.28 4.58,-0.22 6.45,1.1 1.04,-2.19 2.65,-4.17 5.06,-4.17 2.43,0 4,2 5.01,4.2 1.93,-1.39 4.25,-2.3 6.33,-1.18 2.18,1.19 2.58,3.76 2.38,6.21z"/>
   <path class="fil2" d="M39.64 15.91c2.23,-0.51 5.42,-0.81 6.57,1.09 1.21,2 -0.79,4.78 -2.31,6.49 2.19,0.62 5.09,1.89 5.2,4.09 0.1,2.33 -2.99,3.82 -5.15,4.59 1.55,1.68 3.37,4.27 2.3,6.2 -1.11,2.03 -4.46,1.72 -6.7,1.26 0.5,2.23 0.79,5.45 -1.12,6.59 -1.99,1.2 -4.76,-0.8 -6.46,-2.33 -0.63,2.19 -1.91,5.11 -4.12,5.21 -2.33,0.09 -3.8,-2.99 -4.56,-5.15 -1.69,1.55 -4.3,3.37 -6.23,2.29 -2.01,-1.11 -1.7,-4.44 -1.23,-6.68 -2.23,0.49 -5.47,0.78 -6.61,-1.15 -1.19,-1.99 0.8,-4.73 2.34,-6.43 -2.19,-0.64 -5.13,-1.93 -5.21,-4.15 -0.09,-2.32 2.98,-3.78 5.14,-4.53 -1.54,-1.69 -3.37,-4.32 -2.28,-6.26 1.12,-2 4.43,-1.67 6.67,-1.2 -0.48,-2.24 -0.76,-5.5 1.17,-6.63 1.97,-1.16 4.65,0.77 6.34,2.3 0.71,-2.18 2.12,-5.16 4.38,-5.16 2.29,0 3.64,3.06 4.32,5.24 1.66,-1.57 4.3,-3.48 6.27,-2.41 2.03,1.11 1.73,4.48 1.28,6.73z"/>
   <path class="fil3" d="M27.72 13.82c-7.67,0 -13.9,6.23 -13.9,13.9 0,7.68 6.23,13.9 13.9,13.9 7.68,0 13.91,-6.22 13.91,-13.9 0,-7.67 -6.23,-13.9 -13.91,-13.9zm-9.87 -3.26c1.22,-0.72 3.86,1.47 5.15,2.74 -0.97,0.33 -1.92,0.75 -2.84,1.29 -0.92,0.54 -1.76,1.16 -2.51,1.85 -0.48,-1.75 -1.03,-5.16 0.2,-5.88zm9.92 -2.64c1.42,0 2.59,3.22 3.06,4.97 -1,-0.21 -2.04,-0.32 -3.11,-0.32 -1.06,0 -2.1,0.11 -3.1,0.32 0.47,-1.75 1.73,-4.97 3.15,-4.97zm-17.19 9.89c0.7,-1.24 4.08,-0.68 5.83,-0.23 -0.67,0.77 -1.28,1.62 -1.8,2.54 -0.52,0.93 -0.93,1.89 -1.24,2.87 -1.29,-1.27 -3.48,-3.94 -2.79,-5.18zm-2.66 9.96c-0.05,-1.42 3.12,-2.7 4.86,-3.24 -0.18,1.01 -0.25,2.05 -0.21,3.11 0.04,1.07 0.19,2.1 0.43,3.09 -1.76,-0.4 -5.03,-1.54 -5.08,-2.96zm2.65 9.84c-0.73,-1.22 1.45,-3.87 2.71,-5.17 0.33,0.97 0.77,1.92 1.31,2.84 0.54,0.91 1.17,1.75 1.86,2.5 -1.75,0.49 -5.16,1.05 -5.88,-0.17zm7.25 7.26c-1.24,-0.69 -0.7,-4.07 -0.26,-5.83 0.77,0.67 1.63,1.27 2.56,1.79 0.93,0.52 1.89,0.92 2.87,1.22 -1.27,1.31 -3.93,3.51 -5.17,2.82zm9.96 2.66c-1.42,0.05 -2.72,-3.11 -3.26,-4.84 1.01,0.17 2.05,0.23 3.12,0.19 1.06,-0.04 2.09,-0.2 3.08,-0.45 -0.39,1.77 -1.52,5.04 -2.94,5.1zm9.84 -2.66c-1.22,0.73 -3.87,-1.43 -5.18,-2.69 0.97,-0.33 1.92,-0.77 2.83,-1.32 0.91,-0.54 1.75,-1.17 2.5,-1.87 0.49,1.75 1.07,5.15 -0.15,5.88zm7.26 -7.25c-0.69,1.24 -4.07,0.71 -5.83,0.28 0.67,-0.77 1.26,-1.63 1.78,-2.56 0.51,-0.93 0.91,-1.9 1.21,-2.88 1.31,1.26 3.52,3.91 2.84,5.16zm2.65 -9.97c0.06,1.42 -3.1,2.74 -4.83,3.29 0.17,-1.01 0.23,-2.05 0.18,-3.12 -0.05,-1.06 -0.21,-2.09 -0.46,-3.08 1.77,0.39 5.04,1.49 5.11,2.91zm-2.66 -9.83c0.73,1.21 -1.42,3.88 -2.67,5.19 -0.34,-0.97 -0.78,-1.91 -1.33,-2.83 -0.55,-0.91 -1.18,-1.74 -1.88,-2.48 1.74,-0.51 5.14,-1.1 5.88,0.12zm-7.26 -7.26c1.24,0.68 0.73,4.07 0.31,5.83 -0.78,-0.66 -1.64,-1.25 -2.57,-1.76 -0.94,-0.51 -1.9,-0.91 -2.88,-1.2 1.25,-1.32 3.89,-3.54 5.14,-2.87z"/>
  </g>
  <polygon class="fil4" points="0,0 55.45,0 55.45,55.45 0,55.45 "/>
  <rect class="fil5" x="55.45" width="55.45" height="55.45"/>
  <rect class="fil5" x="110.9" width="55.45" height="55.45"/>
  <g id="_2207043897408">
   <path class="fil6" d="M58.65 27.72c0,-13.54 10.98,-24.52 24.52,-24.52 13.54,0 24.52,10.98 24.52,24.52 0,13.54 -10.98,24.52 -24.52,24.52 -13.54,0 -24.52,-10.98 -24.52,-24.52z"/>
   <path class="fil7" d="M59.96 27.72c0,-12.81 10.39,-23.21 23.21,-23.21 12.82,0 23.21,10.4 23.21,23.21 0,12.82 -10.39,23.22 -23.21,23.22 -12.82,0 -23.21,-10.4 -23.21,-23.22z"/>
   <path class="fil8" d="M61.81 27.72c0,-11.79 9.57,-21.36 21.36,-21.36 11.8,0 21.36,9.57 21.36,21.36 0,11.8 -9.56,21.36 -21.36,21.36 -11.79,0 -21.36,-9.56 -21.36,-21.36z"/>
  </g>
  <g id="_2207043901920">
   <path class="fil5" d="M83.17 7.92c-10.93,0 -19.8,8.87 -19.8,19.8 0,10.94 8.87,19.81 19.8,19.81 10.94,0 19.81,-8.87 19.81,-19.81 0,-10.93 -8.87,-19.8 -19.81,-19.8z"/>
   <path class="fil9" d="M83.17 7.92c-1.34,0 -2.65,0.13 -3.91,0.39 7.32,1.82 12.85,9.82 12.85,19.41 0,9.6 -5.53,17.6 -12.85,19.42 1.26,0.25 2.57,0.39 3.91,0.39 10.94,0 19.81,-8.87 19.81,-19.81 0,-10.93 -8.87,-19.8 -19.81,-19.8z"/>
   <path class="fil10" d="M79.26 8.31c-9.07,1.82 -15.89,9.82 -15.89,19.41 0,9.6 6.82,17.6 15.89,19.42 7.32,-1.82 12.85,-9.82 12.85,-19.42 0,-9.59 -5.53,-17.59 -12.85,-19.41z"/>
   <path class="fil11" d="M77.44 31.02c0.07,-0.77 1.25,-0.78 1.36,0 0.32,2.09 1.76,3.5 3.84,3.84 0.72,0.12 0.7,1.29 0,1.36 -2.1,0.22 -3.54,1.75 -3.84,3.83 -0.09,0.69 -1.26,0.7 -1.36,0 -0.29,-2.09 -1.74,-3.55 -3.83,-3.83 -0.72,-0.09 -0.75,-1.27 0,-1.36 2.09,-0.27 3.63,-1.74 3.83,-3.84zm-6.54 -10.55c0.04,-0.49 0.78,-0.49 0.86,0 0.2,1.32 1.11,2.21 2.42,2.43 0.46,0.07 0.45,0.81 0,0.86 -1.32,0.14 -2.24,1.1 -2.42,2.42 -0.06,0.43 -0.8,0.44 -0.86,0 -0.18,-1.32 -1.1,-2.25 -2.42,-2.42 -0.46,-0.06 -0.48,-0.8 0,-0.86 1.32,-0.17 2.29,-1.1 2.42,-2.43z"/>
  </g>
  <g id="_2207043901728">
   <path class="fil6" d="M114.1 27.72c0,-13.54 10.98,-24.52 24.52,-24.52 13.54,0 24.52,10.98 24.52,24.52 0,13.54 -10.98,24.52 -24.52,24.52 -13.54,0 -24.52,-10.98 -24.52,-24.52z"/>
   <path class="fil7" d="M115.41 27.72c0,-12.81 10.39,-23.21 23.21,-23.21 12.82,0 23.21,10.4 23.21,23.21 0,12.82 -10.39,23.22 -23.21,23.22 -12.82,0 -23.21,-10.4 -23.21,-23.22z"/>
   <path class="fil8" d="M117.26 27.72c0,-11.79 9.56,-21.36 21.36,-21.36 11.8,0 21.36,9.57 21.36,21.36 0,11.8 -9.56,21.36 -21.36,21.36 -11.8,0 -21.36,-9.56 -21.36,-21.36z"/>
  </g>
  <g id="_2207043902880">
   <path class="fil5" d="M138.62 7.92c-10.94,0 -19.8,8.87 -19.8,19.8 0,10.94 8.86,19.81 19.8,19.81 10.94,0 19.8,-8.87 19.8,-19.81 0,-10.93 -8.86,-19.8 -19.8,-19.8z"/>
   <path class="fil9" d="M138.62 7.92c-1.34,0 -2.65,0.13 -3.92,0.39 7.33,1.82 12.85,9.82 12.85,19.41 0,9.6 -5.52,17.6 -12.85,19.42 1.27,0.25 2.58,0.39 3.92,0.39 10.94,0 19.8,-8.87 19.8,-19.81 0,-10.93 -8.86,-19.8 -19.8,-19.8z"/>
   <path class="fil12" d="M134.7 8.31c-9.06,1.82 -15.88,9.82 -15.88,19.41 0,9.6 6.82,17.6 15.88,19.42 7.33,-1.82 12.85,-9.82 12.85,-19.42 0,-9.59 -5.52,-17.59 -12.85,-19.41z"/>
   <path class="fil11" d="M132.89 31.02c0.07,-0.77 1.25,-0.78 1.36,0 0.32,2.09 1.76,3.5 3.84,3.84 0.72,0.12 0.7,1.29 0,1.36 -2.1,0.22 -3.55,1.75 -3.84,3.83 -0.09,0.69 -1.26,0.7 -1.36,0 -0.29,-2.09 -1.74,-3.55 -3.83,-3.83 -0.72,-0.09 -0.75,-1.27 0,-1.36 2.09,-0.27 3.63,-1.74 3.83,-3.84zm-6.54 -10.55c0.04,-0.49 0.78,-0.49 0.86,0 0.2,1.32 1.1,2.21 2.42,2.43 0.46,0.07 0.44,0.81 0,0.86 -1.33,0.14 -2.24,1.1 -2.42,2.42 -0.06,0.43 -0.8,0.44 -0.86,0 -0.19,-1.32 -1.11,-2.25 -2.43,-2.42 -0.45,-0.06 -0.47,-0.8 0,-0.86 1.33,-0.17 2.3,-1.1 2.43,-2.43z"/>
  </g>
 </g>
</svg>
]],
[[
<svg version="1.0" xmlns="http://www.w3.org/2000/svg"
 width="905.000000pt" height="1280.000000pt" viewBox="0 0 905.000000 1280.000000"
 preserveAspectRatio="xMidYMid meet">
<metadata>
WS Light1 ]] .. title_color ..
[[</metadata>
<g transform="translate(0.000000,1280.000000) scale(0.100000,-0.100000)"
fill="#]] .. color_light1 .. [[" stroke="none">
<path d="M0 6220 l0 -6130 4525 0 4525 0 0 6130 0 6130 -4525 0 -4525 0 0
-6130z"/>
</g>
</svg>
]],
[[
<svg width="90" height="30" version="1.1" xmlns="http://www.w3.org/2000/svg">
  <rect x="0" y="1" width="30" height="29" fill="#]] .. color_light .. [["/>
  <rect x="30" y="1" width="30" height="29" fill="#]] .. color_base .. [[" fill-opacity="0.3"/>
  <rect x="60" y="1" width="30" height="29" fill="#]] .. color_base .. [[" fill-opacity="0.3"/>
</svg>
]],
},
}

local header
local fileEnd = '.svg'
for j = 1,5 do
local filePath
if j == 1 then
header = 'back'
elseif j == 2 then
header = 'back_active'
elseif j == 3 then
header = 'day'
elseif j == 4 then
header = 'back1'
elseif j == 5 then
header = 'back_item'
end
filePath = pass .. '/img/' .. header .. fileEnd
local fhandle = io.open(filePath, 'w+')
if fhandle then
	fhandle:write(t[i][j]:gsub('\\',''))
	fhandle:close()
--	m_simpleTV.OSD.ShowMessageT({text = 'создан ' .. filePath .. '\n', showTime = 1000 * 10})
else
	m_simpleTV.OSD.ShowMessageT({text = 'ошибка создания ' .. filePath .. '\n', showTime = 1000 * 10})
end
j = j + 1
end

file = io.open(pass .. '/forms/standaloneplst/window.ui', 'r')

if not file then
	return
end

answer = file:read('*a')

local frame1 = answer:match('%<%!%-%-start frame1.-end frame1%-%-%>')

local frame1_up = [[<!--start frame1-->
     <property name="styleSheet">
      <string notr="true"> background-color: #]] .. color_mono_filter .. [[; color: #]] .. color_mono_invers .. [[; selection-background-color: #]] .. color_mono_back .. [[; </string>
     </property>
     <property name="skinBackground" stdset="0">
      <string notr="true">usetransparent=&quot;1&quot;src=&quot;img\back1.svg&quot; can_glass=&quot;2&quot; color1=&quot;0xff]] .. color_for_ui .. [[&quot; type=&quot;0&quot; </string>
     </property>
	 <!--end frame1-->]]

local frame2 = answer:match('%<%!%-%-start frame2.-end frame2%-%-%>')

local frame2_up = [[<!--start frame2-->
     <property name="skinBackground" stdset="0">
      <string notr="true">
	  usetransparent=&quot;1&quot;
	  src=&quot;img\back1.svg&quot;
	  can_glass=&quot;1&quot;
	  color1=&quot;0xff]] .. color_for_ui .. [[&quot;
	  type=&quot;0&quot;</string>
     </property>
	 <!--end frame2-->]]

local frame3 = answer:match('%<%!%-%-start frame3.-end frame3%-%-%>')

local frame3_up = [[<!--start frame3-->
             <color alpha="255">
              <red>]] .. color_mono .. [[</red>
              <green>]] .. color_mono .. [[</green>
              <blue>]] .. color_mono .. [[</blue>
             </color>
	 <!--end frame3-->]]

--debug_in_file(answer:gsub('%<%!%-%-start frame1.-end frame1%-%-%>',frame1_up):gsub('%<%!%-%-start frame2.-end frame2%-%-%>',frame2_up)..'\n','c:/1/exitfile')

file = io.open(pass .. '/forms/standaloneplst/window.ui', 'w+')

file:write(answer:gsub('%<%!%-%-start frame1.-end frame1%-%-%>',frame1_up):gsub('%<%!%-%-start frame2.-end frame2%-%-%>',frame2_up):gsub('%<%!%-%-start frame3.-end frame3%-%-%>',frame3_up):gsub('</ui>.-$','</ui>'))

file:close()

file = io.open(pass .. '/forms/standaloneplst/tree_element_epg_no.ui', 'r')

if not file then
	return
end

answer = file:read('*a')

file = io.open(pass .. '/forms/standaloneplst/tree_element_epg_no.ui', 'w+')

file:write(answer:gsub('%<%!%-%-start frame3.-end frame3%-%-%>',frame3_up):gsub('</ui>.-$','</ui>'))

file:close()

file = io.open(pass .. '/forms/standaloneplst/tree_element_group.ui', 'r')

if not file then
	return
end

answer = file:read('*a')

file = io.open(pass .. '/forms/standaloneplst/tree_element_group.ui', 'w+')

file:write(answer:gsub('%<%!%-%-start frame3.-end frame3%-%-%>',frame3_up):gsub('</ui>.-$','</ui>'))

file:close()

file = io.open(pass .. '/forms/standaloneplst/tree_element_epg_bottom.ui', 'r')

if not file then
	return
end

answer = file:read('*a')

file = io.open(pass .. '/forms/standaloneplst/tree_element_epg_bottom.ui', 'w+')

file:write(answer:gsub('%<%!%-%-start frame3.-end frame3%-%-%>',frame3_up):gsub('</ui>.-$','</ui>'))

file:close()

file = io.open(pass .. '/forms/standaloneplst/tree_element_epg_side.ui', 'r')

if not file then
	return
end

answer = file:read('*a')

file = io.open(pass .. '/forms/standaloneplst/tree_element_epg_side.ui', 'w+')

file:write(answer:gsub('%<%!%-%-start frame3.-end frame3%-%-%>',frame3_up):gsub('</ui>.-$','</ui>'))

file:close()

answer =
[[
<svg version="1.0" xmlns="http://www.w3.org/2000/svg"
 width="40.000000pt" height="40.000000pt" viewBox="0 0 40.000000 40.000000"
 preserveAspectRatio="xMidYMid meet">
<metadata>WS Back</metadata>
  <defs>
    <linearGradient id="grad" x1="0%" x2="0%" y1="0%" y2="100%">
      <stop offset="0%" stop-color="#]] .. gradient[1] .. [[" />
	  <stop offset="100%" stop-color="#]] .. gradient[2] .. [[" />
    </linearGradient>
  </defs>
<rect x="0" y="0" width="40" height="40" fill="url(#grad)"/>
</svg>
]]

file = io.open(pass .. '/img/gradient.svg', 'w+')

file:write(answer)
file:close()

answer =
[[
<svg version="1.0" xmlns="http://www.w3.org/2000/svg"
 width="40.000000pt" height="40.000000pt" viewBox="0 0 40.000000 40.000000"
 preserveAspectRatio="xMidYMid meet">
<metadata>WS Back</metadata>
  <defs>
    <linearGradient id="grad" x1="0%" x2="0%" y1="0%" y2="100%">
      <stop offset="0%" stop-color="#]] .. gradient_activ[1] .. [[" />
	  <stop offset="80%" stop-color="#]] .. gradient_activ[2] .. [[" />
    </linearGradient>
  </defs>
<rect x="0" y="0" width="40" height="40" fill="url(#grad)"/>
</svg>
]]

file = io.open(pass .. '/img/gradient_activ.svg', 'w+')

file:write(answer)
file:close()

local answer1 =
[[
QWidget{
 border: 0px solid #999999;
 background: url(_BASESKINPATH_/img/back.svg) center center center;
 color: #]] .. color_mono_hex .. [[;
 font-weight: 600;
 margin: 0px;
 padding: 0px;
}

QTreeView
{
 background: url(_BASESKINPATH_/img/back.svg) center center center;
 alternate-background-color: rgba(0, 0, 0, 16);
 font: 20px;
}

QTreeView::item:selected
{
 color: #ffffc618;
 font-weight: 600;
 background: #7f7f7f7f;
}

QTreeView::item:hover
{
 background: #66000000;
}

QTreeView::item
{
 
}

#m_Splitter{
 height: 1px;
 width: 1px;
}

#line{
 border-bottom: 1px solid #fff;
}

QScrollBar:vertical {
 border: 0px solid #999999;
 background: rgba(128, 128, 128, 180);
 width:8px;
 border-radius: 4px;
 margin: 0px 0px 0px 0px;
}
QScrollBar::handle:vertical {
 background: qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #474A51, stop: 1 #2F353B);
 min-height: 20px;
 border-radius: 4px;
 }
QScrollBar::handle:vertical:pressed {
 background: qlineargradient( x1: 0, y1: 0, x2: 1, y2: 0, stop: 0 #]] .. color_light1 .. [[, stop: 1 #]] .. color_base .. [[);
 min-height: 20px;
 border-radius: 4px;
 }
QScrollBar::handle:vertical:hover:!pressed {
 background: qlineargradient( x1: 0, y1: 0, x2: 1, y2: 0, stop: 0 #]] .. color_light1 .. [[, stop: 1 #]] .. color_base .. [[);
 min-height: 20px;
 border-radius: 4px;
 }
QScrollBar::add-line:vertical {
 background:  rgba(100, 100, 100, 120);
 height: 0px;
 border: 0px solid #999999;
 border-radius: 4px;
 subcontrol-position: bottom;
 subcontrol-origin: margin;
}
QScrollBar::add-line:vertical:pressed {
 background: qlineargradient( x1: 0, y1: 0, x2: 1, y2: 0, stop: 0 #]] .. color_light1 .. [[, stop: 1 #]] .. color_base .. [[);
 border-radius: 4px;
 border: 0px solid rgba(255, 127, 63, 255);
 }
QScrollBar::add-line:vertical:hover:!pressed {
 background: qlineargradient( x1: 0, y1: 0, x2: 1, y2: 0, stop: 0 #]] .. color_light1 .. [[, stop: 1 #]] .. color_base .. [[);
 border-radius: 4px;
 border: 0px solid rgba(255, 127, 63, 127);
 }
QScrollBar::sub-line:vertical {
 background: rgba(100, 100, 100, 120);
 height: 0px;
 border: 0px solid #999999;
 border-radius: 4px;
 subcontrol-position: top;
 subcontrol-origin: margin;
}
QScrollBar::sub-line:vertical:pressed {
 background: qlineargradient( x1: 0, y1: 0, x2: 1, y2: 0, stop: 0 #]] .. color_light1 .. [[, stop: 1 #]] .. color_base .. [[);
 border-radius: 4px;
 border: 0px solid rgba(255, 127, 63, 255);
 }
QScrollBar::sub-line:vertical:hover:!pressed {
 background: qlineargradient( x1: 0, y1: 0, x2: 1, y2: 0, stop: 0 #]] .. color_light1 .. [[, stop: 1 #]] .. color_base .. [[);
 border-radius: 4px;
 border: 0px solid rgba(255, 127, 63, 127);
 }
QScrollBar:top-arrow:vertical, QScrollBar::bottom-arrow:vertical {
 border: 0px solid grey;
 width: 0px;
 height: 0px;
 background: rgba(100, 100, 100, 120);
 border-radius: 0px;
}
QScrollBar::add-page:vertical, QScrollBar::sub-page:vertical {
 background: none;
}
]]

local answer2 =
[[
#m_ChannelName
{
 background: rgba(0, 0, 0, 0);
 color : #ffffff;
 font: 20px;
 font-weight: 600;
}

#m_CurrentTime
{
 font: 18px;
}

#m_EpgFilterTypeButton
{
 color : #ffffff;
 border: 1px solid #C7D0CC;
 background: qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #C7D0CC, stop: 1 #2F353B);
}

#m_EpgFilterTypeButton:pressed
{
 border: 1px solid #ffffff;
 background: qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #]] .. color_light .. [[, stop: 1 #]] .. color_base .. [[);
}

#m_EpgFilterTypeButton:hover
{
 border: 1px solid #ffffff;
 background: qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #]] .. color_light .. [[, stop: 1 #]] .. color_base .. [[);
}

#m_FilterCombo
{
 color: #]] .. color_mono_invers .. [[;
 border: 0px solid #C7D0CC;
 background-color: #]] .. color_mono_filter .. [[; selection-background-color: #]] .. color_mono_back .. [[;
 font: 14px;
}

#m_EpgNow
{
 color: #]] .. color_base .. [[;
 font: 20px;
}

#m_EpgProgress
{
 text-align: center;
 font: 20px;
 font: bold;
 font-weight: 400;
 background: rgba(222, 222, 222, 44);
 height: 2px;
 border: 1px solid #444444;
 border-radius: 3px;
 color: rgba(255, 255, 255, 255);
}

QProgressBar::chunk
{
 background: qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #]] .. color_light .. [[, stop: 1 #]] .. color_base .. [[);
 width: 8px;
 margin: 2px;
 border: 2px #00FFFF;
 border-radius: 2px;
}

QHeaderView::section
{
 background: url(_BASESKINPATH_/img/gradient.svg) center center;
 color: white;
 padding-left: 4px;
 border: 1px solid #C7D0CC;
 font: 20px;
}

#m_EpgList
{
 background: rgba(]] .. color_mono .. [[, ]] .. color_mono .. [[, ]] .. color_mono .. [[, 24);
 background-attachment: fixed;
 border: 0px solid #8f8f91;
 color: #]] .. color_mono_hex .. [[;
 font: 18px;
 font-weight: 200;
 padding-bottom: 8px;
}

#m_EpgList:active
{
 color : #]] .. color_base .. [[;
}

#m_LabelDesk
{
 margin-top: 4px;
 color: #]] .. color_base .. [[;
 background: rgba(0, 0, 0, 0);
 border: 0px solid #999999;
 font: 20px;
 font-weight: 600;
}

#m_Desc
{
 font: 18px;
 background: rgba(]] .. color_mono .. [[, ]] .. color_mono .. [[, ]] .. color_mono .. [[, 24);
 border: 1px solid #]] .. color_for_ui .. [[;
}

#m_ButtonTime1:hover
{
 color : #eee;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
 border: 1px solid #F5F5F5;
}
#m_ButtonTime2:hover
{
 color : #eee;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
 border: 1px solid #F5F5F5;
}
#m_ButtonTime3:hover
{
 color : #eee;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
 border: 1px solid #F5F5F5;
}
#m_ButtonTime4:hover
{
 color : #eee;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
 border: 1px solid #F5F5F5;
}
#m_ButtonTime5:hover
{
 color : #eee;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
 border: 1px solid #F5F5F5;
}
#m_ButtonTime6:hover
{
 color : #eee;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
 border: 1px solid #F5F5F5;
}
#m_ButtonTime7:hover
{
 color : #eee;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
 border: 1px solid #F5F5F5;
}

#m_ButtonTime1:pressed
{
 color : #eee;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
 border: 1px solid #F5F5F5;
}
#m_ButtonTime2:pressed
{
 color : #eee;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
 border: 1px solid #F5F5F5;
}
#m_ButtonTime3:pressed
{
 color : #eee;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
 border: 1px solid #F5F5F5;
}
#m_ButtonTime4:pressed
{
 color : #eee;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
 border: 1px solid #F5F5F5;
}
#m_ButtonTime5:pressed
{
 color : #eee;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
 border: 1px solid #F5F5F5;
}
#m_ButtonTime6:pressed
{
 color : #eee;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
 border: 1px solid #F5F5F5;
}
#m_ButtonTime7:pressed
{
 color : #eee;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
 border: 1px solid #F5F5F5;
}

#m_ButtonTime1
{
 color : #fff;
 border: 1px solid #C7D0CC;
 background: url(_BASESKINPATH_/img/gradient.svg) center center;
 font: 14px;
 border-radius: 6px;
 width: 57px;
}
#m_ButtonTime2
{
 color : #fff;
 border: 1px solid #C7D0CC;
 background: url(_BASESKINPATH_/img/gradient.svg) center center;
 font: 14px;
 border-radius: 6px;
 width: 57px;
}
#m_ButtonTime3
{
 color : #fff;
 border: 1px solid #C7D0CC;
 background: url(_BASESKINPATH_/img/gradient.svg) center center;
 font: 14px;
 border-radius: 6px;
 width: 57px;
}
#m_ButtonTime4
{
 color : #fff;
 border: 1px solid #C7D0CC;
 background: url(_BASESKINPATH_/img/gradient.svg) center center;
 font: 14px;
 border-radius: 6px;
 width: 57px;
}
#m_ButtonTime5
{
 color : #fff;
 border: 1px solid #C7D0CC;
 background: url(_BASESKINPATH_/img/gradient.svg) center center;
 font: 14px;
 border-radius: 6px;
 width: 57px;
}
#m_ButtonTime6
{
 color : #fff;
 border: 1px solid #C7D0CC;
 background: url(_BASESKINPATH_/img/gradient.svg) center center;
 font: 14px;
 border-radius: 6px;
 width: 57px;
}
#m_ButtonTime7
{
 color : #fff;
 border: 1px solid #C7D0CC;
 background: url(_BASESKINPATH_/img/gradient.svg) center center;
 font: 14px;
 border-radius: 6px;
 width: 57px;
}

#m_TimeSt
{
 background: rgba(0, 0, 0, 0);
 color : #ffffff;
 font: 20px;
}

#m_TimeEnd
{
 background: rgba(0, 0, 0, 0);
 color : #ffffff;
 font: 20px;
}

#m_ButtonTimeNow
{
 padding:4px;

 font-size: 18px;
 border-radius: 2px;
 border: 1px solid #C7D0CC;
 background: url(_BASESKINPATH_/img/gradient.svg) center center;
}

#m_ButtonTimeNow:hover
{
 color: #eee;
 border: 1px solid #F5F5F5;
 border-radius: 2px;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
}

#m_ButtonTimeNow:pressed
{
 color: #eee;
 border: 1px solid #F5F5F5;
 border-radius: 2px;
 background: url(_BASESKINPATH_/img/gradient_activ.svg) center center;
}

#m_ButtonTimeUp
{
 background: url(_BASESKINPATH_/img/butr.png) center center ;
 background-repeat: no-repeat;
 border: 0px solid #C7D0CC;
 color : #bbb;
 font: 18px;
 border-radius: 6px;
}

#m_ButtonTimeUp:hover
{
 background: url(_BASESKINPATH_/img/butr.png) center center qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #]] .. color_base .. [[, stop: 1 #]] .. color_base .. [[);
 background-repeat: no-repeat;
 border: 1px solid #F5F5F5;
 color: #eee;
 font: 18px;
 border-radius: 6px;
}

#m_ButtonTimeUp:pressed
{
 background: url(_BASESKINPATH_/img/butr.png) center center qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #]] .. color_base .. [[, stop: 1 #]] .. color_base .. [[);
 background-repeat: no-repeat;
 border: 1px solid #F5F5F5;
 color: #eee;
 font: 18px;
 border-radius: 6px;
}

#m_ButtonTimeDown
{
 background: url(_BASESKINPATH_/img/butl.png) center center ;
 background-repeat: no-repeat;
 border: 0px solid #C7D0CC;
 color : #bbb;
 font: 18px;
 border-radius: 6px;
}

#m_ButtonTimeDown:hover
{
 background: url(_BASESKINPATH_/img/butl.png) center center qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #]] .. color_base .. [[, stop: 1 #]] .. color_base .. [[);
 background-repeat: no-repeat;
 border: 1px solid #F5F5F5;
 color: #eee;
 font: 18px;
 border-radius: 6px;
}

#m_ButtonTimeDown:pressed
{
 background: url(_BASESKINPATH_/img/butl.png) center center qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #]] .. color_base .. [[, stop: 1 #]] .. color_base .. [[);
 background-repeat: no-repeat;
 border: 1px solid #F5F5F5;
 color: #eee;
 font: 18px;
 border-radius: 6px;
}
]]

local answer3 =
[[
QComboBox
{
 background: rgba(0, 0, 0, 32);
 border: 1px solid #C7D0CC;
 border-radius: 2px;
 padding: 2px;
 font-size: 18px;
 font-weight: 200;
}

QGroupBox
{
 background: rgba(0, 0, 0, 0);
 border: 0px solid #C7D0CC;
 border-radius: 0px;
 color: #]] .. color_mono_hex .. [[;
 font: bold 20px;
 max-width: 1200px;
 min-width: 120px;
 margin: 4px;
 padding-top: 20px;
}

QGroupBox:title
{
 background: rgba(0, 0, 0, 0);
 border: 0px solid #C7D0CC;
 border-radius: 0px;
 color: #]] .. color_mono_hex .. [[;
 margin: 8px;
 padding-top: -4px;
}

QLabel
{
 background: rgba(222, 222, 0, 0);
 border: 0px solid #C7D0CC;
 border-radius: 2px;
 color: #]] .. color_mono_hex .. [[;
 font-size: 16px;
 font-weight: 600;
}

QDoubleSpinBox
{
 border: 1px solid #C7D0CC;
 background: rgba(0, 0, 0, 32);
 border-radius: 2px;
 color: #]] .. color_mono_hex .. [[;
 padding: 2px;
 font-size: 16px;
 font-weight: 600;
}

QLineEdit
{
 box-sizing: border-box;
 background: rgba(111, 111, 111, 55);
 border: 1px solid #C7D0CC;
 border-radius: 2px;
 color: #]] .. color_mono_hex .. [[;
 font-size: 16px;
 padding: 3px;
 font-weight: 400;
}

QPushButton
{
 background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #C7D0CC, stop: 0.75 #2F353B);
 border: 1px solid #C7D0CC;
 border-radius: 2px;
 color : #fff;
 padding: 3px;
 text-align: center;
 font-size: 16px;
 font-weight: 200;
 cursor: pointer;
}

QPushButton:hover
{
 color: #eee;
 border: 1px solid #F5F5F5;
 border-radius: 2px;
 background: qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #]] .. color_light1 .. [[, stop: 1 #]] .. color_black1 .. [[);
}

QPushButton:pressed
{
 color: #eee;
 border: 1px solid #F5F5F5;
 border-radius: 2px;
 background: qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #]] .. color_light .. [[, stop: 1 #]] .. color_base .. [[);
}

QToolButton
{
 background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #C7D0CC, stop: 0.75 #2F353B);
 border: 1px solid #C7D0CC;
 border-radius: 2px;
 color : #fff;
 padding: 3px;
 text-align: center;
 font-size: 16px;
 font-weight: 200;
 cursor: pointer;
}

QToolButton:hover
{
 color: #eee;
 border: 1px solid #F5F5F5;
 border-radius: 2px;
 background: qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #]] .. color_light .. [[, stop: 1 #]] .. color_base .. [[);
}
QToolButton:pressed
{
 color: #eee;
 border: 1px solid #F5F5F5;
 border-radius: 2px;
 background: qlineargradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #]] .. color_light .. [[, stop: 1 #]] .. color_base .. [[);
}

#m_PermDesc
{
 border: 1px solid #C7D0CC;
 background: rgba(111, 111, 111, 55);
 border-radius: 2px;
}

#m_Address
{
 background: rgba(0, 0, 0, 16);
 color: #]] .. color_mono_hex .. [[;
 font: bold 16px;
 padding-top: 4px;
}

#m_RealAddres
{
 background: rgba(0, 0, 0, 16);
 color: #]] .. color_mono_hex .. [[;
 font: bold 16px;
 padding-top: 4px;
}

#m_SlaveAddress
{
 background: rgba(0, 0, 0, 16);
 color: #]] .. color_mono_hex .. [[;
 font: bold 16px;
 padding-top: 4px;
}
]]

file = io.open(pass .. '/includeui/appStylesheet.qss', 'w+')

file:write(answer1 .. answer2 .. answer3)
file:close()

m_simpleTV.Config.Apply('NEED_STANDALONE_PLAYLIST_UPDATE')
