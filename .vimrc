" vi
set nocompatible

" vim
set ambiwidth=double
set autoindent
set autoread
set backspace=indent,eol,start
set cryptmethod=blowfish2
set diffopt=internal,algorithm:histogram
set encoding=utf-8
set fileencoding=utf-8
set foldcolumn=1
set foldmethod=indent
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set list
set listchars=tab:>-,eol:<,trail:-
set relativenumber
set showcmd
set smartcase
set smartindent
set splitbelow
set splitright
set noswapfile
set nowritebackup
syntax enable
autocmd InsertEnter *
	\ set cursorcolumn cursorline number norelativenumber colorcolumn=40,80,120,160
autocmd InsertLeave *
	\ set nocursorcolumn nocursorline nonumber relativenumber colorcolumn=
if has('unix')
	set clipboard=unnamedplus
	if has('gui_running')
		set guifont=Source\ Code\ Pro\ Light\ 13.5
	endif
elseif has('win64')
	set clipboard=unnamed
	set shellcmdflag=/u/c
	if has('gui_running')
		autocmd GUIEnter * winpos 0 0
		autocmd InsertEnter * set noimdisable
		autocmd InsertLeave * set imdisable
		set guifont=Source_Code_Pro_Light:h13.5
		set guifontwide=Sarasa_Mono_TC_Light:h17
	endif
endif
if has('gui_running')
	cnoremap <A-h> <Left>
	cnoremap <A-l> <Right>
	cnoremap <A-j> <Down>
	cnoremap <A-k> <Up>
	inoremap <A-h> <Left>
	inoremap <A-l> <Right>
	inoremap <A-j> <Down>
	inoremap <A-k> <Up>
	nnoremap <expr> <A-d> &diff ? ":diffoff<CR>" : ":diffthis<CR>"
	nnoremap <A-e> <C-w>=
	nnoremap <A-m> <C-w>_
	nnoremap <A-w> :set wrap!<CR>
	highlight Normal guibg=black guifg=white
	highlight User1 guibg=white guifg=darkred
	highlight User2 guibg=white guifg=darkgreen
	highlight User3 guibg=white guifg=darkblue
	highlight User4 guibg=white guifg=darkcyan
	highlight User5 guibg=white guifg=darkmagenta
	highlight User6 guibg=white guifg=darkyellow
	set guioptions-=e
	set guioptions-=m
	set guioptions-=T
	set statusline=[%4*%t%*:%4*%P%*@%4*%{bufnr('%')}%*]
	set statusline+=[%5*%{&fileencoding}%*(%5*%{&bomb}%*)%5*%{&fileformat}%*]
	set statusline+=[%6*%M%R%Y%*]
	set statusline+=%=
	if has('nvim')
		" vim-signify
			set statusline+=%1*%{sy#repo#get_stats_decorated()}%*
	endif
	set statusline+=[%1*%{len(filter(range(1,bufnr('$')),'buflisted(v:val)'))}%*]
	set statusline+=[%1*%{get(undotree(),'seq_cur')}%*/%1*%{get(undotree(),'seq_last')}%*]
	set statusline+=[%1*%B%*]
	set statusline+=[%2*%{mode()}%*]
	set statusline+=[%2*%{&encoding}%*]
	set statusline+=[%2*%{&wrap}%*]
	set statusline+=[%3*%l%*,%3*%c%*@%3*%L%*]
else
	set statusline=[%t:%P@%{bufnr('%')}]
	set statusline+=[%{&fileencoding}(%{&bomb})%{&fileformat}]
	set statusline+=[%M%R%Y]
	set statusline+=%=
	if has('nvim')
		" vim-signify
			set statusline+=%{sy#repo#get_stats_decorated()}
	endif
	set statusline+=[%{len(filter(range(1,bufnr('$')),'buflisted(v:val)'))}]
	set statusline+=[%{get(undotree(),'seq_cur')}/%{get(undotree(),'seq_last')}]
	set statusline+=[%B]
	set statusline+=[%{mode()}]
	set statusline+=[%{&encoding}]
	set statusline+=[%{&wrap}]
	set statusline+=[%l,%c@%L]
endif
if has('nvim')
	nnoremap <expr> <A-d> &diff ? ":diffoff<CR>" : ":diffthis<CR>"
	nnoremap <A-e> <C-w>=
	nnoremap <A-m> <C-w>_
	nnoremap <expr> <A-n> &wrap ? ":enew<CR>:diffthis<CR>:0read !git diff '#'<CR>:setlocal nomodifiable nomodified readonly<CR>"
		\ : ":enew<CR>:diffthis<CR>:0read !hg diff '#'<CR>:setlocal nomodifiable nomodified readonly<CR>"
	nnoremap <expr> <A-p> &wrap ? ":%!perl -e 'print sort <>'<CR>:echo 'sort (perl)'<CR>"
		\ : ":%!python -c 'import sys ; sys.stdout.writelines(sorted(sys.stdin.readlines()))'<CR>:echo 'sort (python)'<CR>"
	nnoremap <expr> <A-r> &wrap ? ":%!perl -e 'print reverse sort <>'<CR>:echo 'sort reverse (perl)'<CR>"
		\ : ":%!python -c 'import sys ; sys.stdout.writelines(sorted(sys.stdin.readlines(), reverse=True))'<CR>:echo 'sort reverse (python)'<CR>"
	nnoremap <expr> <A-s> &wrap ? ":%!sort -k 2<CR>:echo 'sort (sort -k 2)'<CR>"
		\ : ":%!sort -k 2 -r<CR>:echo 'sort reverse (sort -k 2 -r)'<CR>"
	nnoremap <A-w> :set wrap!<CR>
else
	nnoremap <A-j> ]c
	nnoremap <A-k> [c
endif

" CJK_Font
if has('gui_running') && has('unix')
	function! s:CJK_Font(mode)
		if a:mode == 0
			set guifontwide=Noto\ Sans\ CJK\ TW\ Light\ 16
		elseif a:mode == 1
			set guifontwide=Noto\ Sans\ CJK\ CN\ Light\ 16
		elseif a:mode == 2
			set guifontwide=Noto\ Sans\ CJK\ JP\ Light\ 16
		elseif a:mode == 3
			set guifontwide=Noto\ Sans\ CJK\ KR\ Light\ 16
		endif
	endfunction
	call <SID>CJK_Font(0)
	let s:cjk_font_select = 1
	function! s:CJK_Font_Select()
		call <SID>CJK_Font(s:cjk_font_select)
		let s:cjk_font_select = (s:cjk_font_select + 1) % 4
	endfunction
	nnoremap <A-f> :call <SID>CJK_Font_Select()<CR>:echo 'guifontwide ='&guifontwide<CR>
endif

" Diff_Pos
if has('nvim')
	function! s:Diff_Pos(mode)
		while a:mode == 0
			let s:startpos = line('.')
			:execute "normal \<Plug>(signify-prev-hunk)"
			let s:endpos = line('.')
			if s:startpos == s:endpos
				:execute "normal \<Plug>(signify-next-hunk)"
				:execute "normal \<Plug>(signify-prev-hunk)"
				echo 'Diff Position (vim-signify) = First'
				break
			end
		endwhile
		while a:mode == 1
			let s:startpos = line('.')
			:execute "normal \<Plug>(signify-next-hunk)"
			let s:endpos = line('.')
			if s:startpos == s:endpos
				:execute "normal \<Plug>(signify-prev-hunk)"
				:execute "normal \<Plug>(signify-next-hunk)"
				echo 'Diff Position (vim-signify) = Last'
				break
			end
		endwhile
	endfunction
else
	function! s:Diff_Pos(mode)
		while a:mode == 0
			let s:startpos = line('.')
			normal! [c
			let s:endpos = line('.')
			if s:startpos == s:endpos
				normal! ]c
				normal! [c
				echo 'Diff Position (vimdiff) = First'
				break
			end
		endwhile
		while a:mode == 1
			let s:startpos = line('.')
			normal! ]c
			let s:endpos = line('.')
			if s:startpos == s:endpos
				normal! [c
				normal! ]c
				echo 'Diff Position (vimdiff) = Last'
				break
			end
		endwhile
	endfunction
endif
nnoremap <A-h> :call <SID>Diff_Pos(0)<CR>
nnoremap <A-l> :call <SID>Diff_Pos(1)<CR>

" Highlight_Group
if has('gui_running') || has('nvim')
	function! s:Highlight_Group(mode)
		let s:highlight_group_path = expand('%:p:h') . "/highlight.vim"
		if a:mode == 0 && filereadable(s:highlight_group_path)
			syntax clear
			echo 'Highlight Group = Disable'
		elseif a:mode == 1 && filereadable(s:highlight_group_path)
			syntax clear
			execute 'source ' s:highlight_group_path
			if g:highlight_group =~ '[0-4]'
				echo 'Highlight Group = Enable' '(' g:highlight_group ')'
			endif
		else
			echo 'Highlight Group = n/a'
		endif
	endfunction
	let g:highlight_group = 1
	function! s:Highlight_Group_Select(mode)
		if a:mode == 0
			let g:highlight_group_temp = g:highlight_group
			if g:highlight_group == 0
				call <SID>Highlight_Group(1)
				let g:highlight_group = 1
			elseif g:highlight_group >= 1 && g:highlight_group <= 4
				call <SID>Highlight_Group(1)
				let g:highlight_group = g:highlight_group + 1
			elseif g:highlight_group == 5
				let g:highlight_group = 0
				call <SID>Highlight_Group(0)
			endif
		elseif a:mode == 1
			let g:highlight_group = 0
			call <SID>Highlight_Group(0)
			let g:highlight_group = g:highlight_group_temp
		endif
	endfunction
	nnoremap <A-b> :keeppatterns s/\v「\|」\|\(\|\)/\={'「':'(','」':')','(':'「',')':'」'}[submatch(0)]/g<CR>
	nnoremap <expr> <A-B> &wrap ? ":keeppatterns s/\"/「/<CR>:keeppatterns s/\\v.*\\zs\"/」/<CR>"
		\ : ":keeppatterns s/\"/(/<CR>:keeppatterns s/\\v.*\\zs\"/)/<CR>"
	nnoremap <expr> <A-g> &wrap ? ":call <SID>Highlight_Group_Select(0)<CR>"
		\ : ":call <SID>Highlight_Group_Select(1)<CR>"
endif
