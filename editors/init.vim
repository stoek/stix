"allow cursor past final item
set ve+=onemore
set invhlsearch
set tabstop=4


" turn hybrid line numbers on
set number relativenumber
set nu rnu

let g:coq_settings = { 'display.icons.mode': 'none' }
		
set termguicolors
command GI %! goimports

nnoremap <S-h> :call ToggleHiddenAll()<CR>
