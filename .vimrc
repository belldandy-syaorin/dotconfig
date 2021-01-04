" vi
set nocompatible

" vim-pathogen
if filereadable(expand('$VIMRUNTIME/autoload/pathogen.vim'))
	\ || filereadable(expand('$VIM/vimfiles/autoload/pathogen.vim'))
	let s:use_pathogen = 1
else
	let s:use_pathogen = 0
endif
if has('unix') && $USER == 'root'
	let s:use_root = 1
else
	let s:use_root = 0
endif
if s:use_pathogen == 1 && s:use_root == 0
	execute pathogen#infect()
endif

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
	map! <A-h> <Left>
	map! <A-l> <Right>
	map! <A-j> <Down>
	map! <A-k> <Up>
	nmap <expr> <A-d> &diff ? ":diffoff<CR>" : ":diffthis<CR>"
	nmap <A-e> <C-w>=
	nmap <A-m> <C-w>_
	nmap <A-w> :set wrap!<CR>
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
	if (&loadplugins == 1) && s:use_pathogen == 1 && s:use_root == 0
		" syntastic
			set statusline+=%1*%{SyntasticStatuslineFlag()}%*
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
	if (&loadplugins == 1) && s:use_pathogen == 1 && s:use_root == 0
		" syntastic
			set statusline+=%{SyntasticStatuslineFlag()}
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
		if s:cjk_font_select == 0
			call <SID>CJK_Font(s:cjk_font_select)
			let s:cjk_font_select = 1
		elseif s:cjk_font_select < 4
			call <SID>CJK_Font(s:cjk_font_select)
			let s:cjk_font_select = s:cjk_font_select + 1
			if s:cjk_font_select == 4
				let s:cjk_font_select = 0
			end
		endif
	endfunction
	nmap <A-f> :call <SID>CJK_Font_Select()<CR>:echo 'guifontwide ='&guifontwide<CR>
endif

" Diff_Pos
if (&loadplugins == 1) && s:use_pathogen == 1 && s:use_root == 0
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
if has('gui_running')
	nmap <A-h> :call <SID>Diff_Pos(0)<CR>
	nmap <A-l> :call <SID>Diff_Pos(1)<CR>
endif

" Highlight_Group
if has('gui_running')
	function! s:Highlight_Group(mode)
		if has('unix')
			let s:highlight_group_path = expand('%:h') . "/highlight.vim"
		elseif has('win64')
			let s:highlight_group_path = expand('%:h') . "\\highlight.vim"
		endif
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
	let g:highlight_group = 0
	function! s:Highlight_Group_Select(mode)
		if a:mode == 0
			if g:highlight_group == 0
				call <SID>Highlight_Group(1)
				let g:highlight_group = 1
			elseif g:highlight_group < 5
				call <SID>Highlight_Group(1)
				let g:highlight_group = g:highlight_group + 1
			elseif g:highlight_group == 5
				let g:highlight_group = 0
				call <SID>Highlight_Group(0)
			endif
		elseif a:mode == 1
			if g:highlight_group == 0
				let g:highlight_group = 4
				call <SID>Highlight_Group(1)
			elseif g:highlight_group < 5
				let g:highlight_group = g:highlight_group - 1
				call <SID>Highlight_Group(1)
				if g:highlight_group == 0
					let g:highlight_group = 5
				end
			elseif g:highlight_group == 5
				let g:highlight_group = 0
				call <SID>Highlight_Group(0)
			endif
		endif
	endfunction
	nmap <A-b> :keeppatterns s/\v「\|」\|\(\|\)/\={'「':'(','」':')','(':'「',')':'」'}[submatch(0)]/g<CR>
	nmap <expr> <A-g> &wrap ? ":call <SID>Highlight_Group_Select(0)<CR>"
		\ : ":call <SID>Highlight_Group_Select(1)<CR>"
endif

" Mercurial
if has('gui_running') && has('unix')
	function! s:Mercurial(mode)
		if isdirectory(expand('%:h') . "/.hg")
			if a:mode == 0
				:!hg status "%"
			elseif a:mode == 1
				:new|resize|diffthis|0read !hg diff "#"
			elseif a:mode == 2
				:tabnew|diffthis|0read !hg diff "#"
			endif
		else
			echo 'Repository = n/a'
		endif
	endfunction
	nmap <A-n> :call <SID>Mercurial(1)<CR>
	nmap <A-t> :call <SID>Mercurial(2)<CR>
	nmap <A-v> :call <SID>Mercurial(0)<CR>
	nmap <A-N> :new<CR>:resize<CR>:diffthis<CR>:0read !hg diff "#"<CR>
	nmap <A-T> :tabnew<CR>:diffthis<CR>:0read !hg diff "#"<CR>
	nmap <A-V> :!hg status "%"<CR>
endif

" linux
if has('gui_running') && has('unix')
	nmap <expr> <A-p> &wrap ? ":%!perl -e 'print sort <>'<CR>:echo 'sort (perl)'<CR>"
		\ : ":%!python -c 'import sys ; sys.stdout.writelines(sorted(sys.stdin.readlines()))'<CR>:echo 'sort (python)'<CR>"
	nmap <expr> <A-r> &wrap ? ":%!perl -e 'print reverse <>'<CR>:echo 'sort reverse (perl)'<CR>"
		\ : ":%!python -c 'import sys ; sys.stdout.writelines(sorted(sys.stdin.readlines(), reverse=True))'<CR>:echo 'sort reverse (python)'<CR>"
	nmap <A-P> :%!sort -k 2<CR>:echo 'sort (sort -k 2)'<CR>
	nmap <A-R> :%!sort -k 2 -r<CR>:echo 'sort reverse (sort -k 2 -r)'<CR>
endif

" loadplugins
if (&loadplugins == 1) && s:use_pathogen == 1 && s:use_root == 0
	" syntastic
		let g:syntastic_always_populate_loc_list = 1
		let g:syntastic_auto_loc_list = 1
	" vim-signify
		let g:signify_disable_by_default = 1
		let g:signify_line_highlight = 0
	if has('gui_running')
		" syntastic
			nmap <A-c> :SyntasticCheck<CR>
			nmap <A-C> :SyntasticReset<CR>
		" vim-signify
			function! s:Signify_Line_Highlight_Toggle()
				if g:signify_line_highlight == 0
					let g:signify_line_highlight = 1
				elseif g:signify_line_highlight == 1
					let g:signify_line_highlight = 0
				endif
			endfunction
			nmap <expr> <A-j> &diff ? "]c" : "<Plug>(signify-next-hunk)"
			nmap <expr> <A-k> &diff ? "[c" : "<Plug>(signify-prev-hunk)"
			nmap <expr> <A-s> &diff ? ":diffoff<CR>" : ":SignifyToggle<CR>"
			nmap <A-S> :call <SID>Signify_Line_Highlight_Toggle()<CR>:echo 'g:signify_line_highlight =' g:signify_line_highlight<CR>
	endif
else
	if has('gui_running')
		nmap <A-j> ]c
		nmap <A-k> [c
	endif
endif
