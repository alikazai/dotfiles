return {
	{ -- Intellisense and Snippets
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		dependencies = {
			{ "neovim/nvim-lspconfig" },
			{
				"williamboman/mason.nvim",
				build = function() pcall(vim.cmd, "MasonUpdate") end,
			},
			{ "williamboman/mason-lspconfig.nvim" },
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "L3MON4D3/LuaSnip" },
			{ 'onsails/lspkind.nvim' },
		},
		config = function()
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
				callback = function(event)
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight',
							{ clear = false })
						vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})
						vim.api.nvim_create_autocmd('LspDetach', {
							group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
							end,
						})
					end
					if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
						map('<leader>th', function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
						end, '[T]oggle Inlay [H]ints')
					end
				end,
			})
			local lsp = require("lsp-zero")
			lsp.preset("recommended")
			lsp.extend_cmp()
			lsp.on_attach(function(client, bufnr)
				lsp.default_keymaps({
					buffer = bufnr,
					preserve_mapping = false,
				})
				local opts = { buffer = bufnr }
				vim.keymap.set("n", "<leader>ws", function()
					vim.lsp.buf.workspace_symbol()
				end, opts)
				vim.keymap.set("n", "<leader>a", function()
					vim.lsp.buf.code_action()
				end, opts)
				lsp.buffer_autoformat()
			end)
			--[[
			require('lspconfig').jdtls.setup({
			  on_attach = function(client, bufnr)
				lsp.default_keymaps({buffer = bufnr})
				lsp.buffer_autoformat()
			  end
			})
			lsp.set_server_config({
				single_file_support = false,
				capabilities = {
					textDocument = {
						foldingRange = {
							dynamicRegistration = false,
							lineFoldingOnly = true,
						},
						completion = {
							completionItem = {
								snippetSupport = true,
								resolveSupport = {
									properties = {
										"documentation",
										"detail",
										"additionalTextEdits",
									},
								},
							},
						},
					},
				},
			})
			--]]
			lsp.setup()
			local cmp = require("cmp")
			local cmp_action = require('lsp-zero').cmp_action()
			cmp.setup({
				sources = {
					{ name = 'nvim_lsp' },
					{ name = 'path' },
					{ name = 'buffer' },
				},
				mapping = {
					["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
					["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
					["<C-y>"] = cmp.mapping(
						cmp.mapping.confirm {
							behavior = cmp.ConfirmBehavior.Insert,
							select = true,
						},
						{ "i", "c" }
					),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-f>'] = cmp_action.luasnip_jump_forward(),
					['<C-b>'] = cmp_action.luasnip_jump_backward(),
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
			})
			cmp.setup.filetype({ 'sql' }, {
				sources = {
					{ name = "vim-dadbod-completion" },
					{ name = "buffer" },
				},
			})
			local ls = require "luasnip"
			ls.config.set_config {
				history = false,
				updateevents = "TextChanged,TextChangedI",
			}
			for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/snippets/*.lua", true)) do
				loadfile(ft_path)()
			end
			vim.keymap.set({ "i", "s" }, "<c-k>", function()
				if ls.expand_or_jumpable() then
					ls.expand_or_jump()
				end
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<c-j>", function()
				if ls.jumpable(-1) then
					ls.jump(-1)
				end
			end, { silent = true })
			vim.diagnostic.config({
				virtual_text = true,
			})
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"ltex",
					"jdtls",
					"marksman",
					"tflint",
					"terraformls",
					"yamlls",
					"bufls",
					"tailwindcss",
					"clangd",
					"pyright",
					"cssls",
					"html",
					"tsserver",
					"lua_ls",
					"rust_analyzer",
					"golangci_lint_ls",
					"gopls",
					"sqlls",
				},
			})
			require("mason-nvim-dap").setup({
				ensure_installed = {},
				automatic_installation = true,
				handlers = {}
			})
		end,
	},

	{ -- Debugging
		"mfussenegger/nvim-dap",
		"jay-babu/mason-nvim-dap.nvim",
		'leoluz/nvim-dap-go',
		"rcarriga/nvim-dap-ui",
		'folke/neodev.nvim',
		'theHamsta/nvim-dap-virtual-text',
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
			'nvim-neotest/nvim-nio',
		},
		config = function()
			require("dapui").setup()
			require("neodev").setup({
				library = { plugins = { "nvim-dap-ui" }, types = true },
			})
			require("nvim-dap-virtual-text").setup()
			require('dap-go').setup()
			local dap, dapui = require("dap"), require("dapui")
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
			require('mason-nvim-dap').setup {
				automatic_installation = true,
				handlers = {},
				ensure_installed = {
					'delve',
				},
			}
		end,
	},

	{ -- Code Objects
		"nvim-treesitter/nvim-treesitter",
		dependencies = { 'windwp/nvim-ts-autotag' },
		build = ":TSUpdate",
		config = function()
			require 'nvim-treesitter.install'.compilers = { "clang" }
			require("nvim-treesitter.configs").setup({
				ensure_installed = { 'bash', 'c', 'cpp', 'css', 'dart', 'dockerfile', 'git_config',
					'gitattributes',
					'gitignore', 'go', 'gomod', 'gosum', 'gowork', 'html', 'java', 'javascript', 'json', 'lua', 'make',
					'markdown', 'proto', 'python', 'query', 'rust', 'scss', 'sql', 'toml', 'typescript', 'vim', 'vimdoc',
					'yaml' },
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				autotag = {
					enable = true,
				}
			})
		end,
	},

	{ -- Pin Headers
		"nvim-treesitter/nvim-treesitter-context",
	},

	{ -- Display Statuses
		"j-hui/fidget.nvim",
		config = function() require("fidget").setup() end,
	},

	{ -- Disect Token Tree
		"nvim-treesitter/playground"
	},

	{ -- Fuzzy Picker
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	{ -- Surround Motions
		'echasnovski/mini.nvim',
		version = '*',
		config = function()
			require('mini.ai').setup { n_lines = 500 }
			require('mini.surround').setup()
			require('mini.pairs').setup()
			--[[
			local statusline = require 'mini.statusline'
			statusline.setup { use_icons = vim.g.have_nerd_font }
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return '%2l:%-2v'
			end
			--]]
		end,
	},

	{ -- Smart Help
		'folke/which-key.nvim',
		event = 'VimEnter',
		config = function()
			require('which-key').setup()
		end,
	},

	{ -- Rainbow Indentation Guides
		'lukas-reineke/indent-blankline.nvim',
		main = 'ibl',
		opts = function()
			require("ibl").setup()
			local highlight = {
				"RainbowRed",
				"RainbowYellow",
				"RainbowBlue",
				"RainbowOrange",
				"RainbowGreen",
				"RainbowViolet",
				"RainbowCyan",
			}
			local hooks = require "ibl.hooks"
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
				vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
				vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
				vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
				vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
				vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
				vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
			end)
			require("ibl").setup { indent = { highlight = highlight } }
		end,
	},

	{ -- Improved Floating UIs
		'stevearc/dressing.nvim',
		opts = {},
	},

	--[[
	{ -- Theme Tokyo Night
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			require("tokyonight").setup({
				-- rose-pine
				disable_background = true,
				disable_float_background = true,
				-- tokyonight
				transparent = true,
				on_highlights = function(hl, c)
					local textColor = c.fg_dark
					hl.TelescopeNormal = {
						-- bg = c.bg_dark,
						bg = 'none',
						fg = textColor,
					}
					hl.TelescopeBorder = {
						-- bg = c.bg_dark,
						bg = 'none',
						fg = textColor,
					}
					hl.TelescopePromptNormal = {
						-- bg = prompt,
						bg = 'none',
						fg = textColor,
					}
					hl.TelescopePromptBorder = {
						-- bg = prompt,
						bg = 'none',
						fg = textColor,
					}
					hl.TelescopePromptTitle = {
						-- bg = prompt,
						bg = 'none',
						fg = textColor,
					}
					hl.TelescopePreviewTitle = {
						-- bg = c.bg_dark,
						bg = 'none',
						fg = textColor,
					}
					hl.TelescopeResultsTitle = {
						-- bg = c.bg_dark,
						bg = 'none',
						fg = textColor,
					}
				end,
			})
			function ColorMyPencils(color)
				color = color or "tokyonight"
				vim.cmd.colorscheme(color)
				vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
				vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			end
	
			ColorMyPencils()
		end,
	},
	--]]

	{ -- Theme Gruvbox
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = function()
			require("gruvbox").setup({
				transparent_mode = true,
			})
			vim.cmd.colorscheme("gruvbox")
		end,
		opts = ...
	},

	--[[
	{ -- Theme Rose Pine
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			require("rose-pine").setup({
				disable_background = true,
				disable_float_background = true,
			})
			function ColorMyPencils(color)
				color = color or "rose-pine"
				vim.cmd.colorscheme(color)
				vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
				vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			end
	
			ColorMyPencils()
		end,
	},
	--]]

	{ -- Inline Diagnostics
		"folke/trouble.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function() require("trouble").setup({}) end,
	},

	{ -- Cute Statusbar
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			--[[
			local custom_auto = require("lualine.themes.auto")
			custom_auto.normal.c.bg = nil
			custom_auto.insert.c.bg = nil
			custom_auto.visual.c.bg = nil
			custom_auto.replace.c.bg = nil
			custom_auto.command.c.bg = nil
			--]]
			require("lualine").setup({
				options = {
					--theme = 'tokyonight',
					theme = 'auto',
					section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
				},
			})
		end,
	},

	{ -- Multifiles Jumper
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = {
			"nvim-lua/plenary.nvim",
			'nvim-telescope/telescope.nvim',
		},
		opts = function()
			local harpoon = require('harpoon')
			harpoon:setup({})
			local conf = require("telescope.config").values
			local function toggle_telescope(harpoon_files)
				local file_paths = {}
				for _, item in ipairs(harpoon_files.items) do
					table.insert(file_paths, item.value)
				end
				require("telescope.pickers").new({}, {
					prompt_title = "Harpoon",
					finder = require("telescope.finders").new_table({
						results = file_paths,
					}),
					previewer = conf.file_previewer({}),
					sorter = conf.generic_sorter({}),
				}):find()
			end
			vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
				{ desc = "Open harpoon window" })
		end,
	},

	{ -- Refactoring
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("refactoring").setup()
		end,
	},

	{ -- Disect Undo Tree
		"mbbill/undotree",
	},

	{ -- Git Integration
		"lewis6991/gitsigns.nvim",
	},

	{ -- LaTeX
		"lervag/vimtex",
	},

	{ -- Markdown
		'MeanderingProgrammer/markdown.nvim',
		name = 'render-markdown',
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		config = function()
			require('render-markdown').setup({})
		end,
	},

	{ -- SQL/NoSQL Client
		"tpope/vim-dadbod",
		"kristijanhusak/vim-dadbod-completion",
		"kristijanhusak/vim-dadbod-ui",
	},

	{ -- File Handler
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup {
				columns = { "icon" },
				keymaps = {
					["<C-h>"] = false,
					["<M-h>"] = "actions.select_split",
				},
				view_options = {
					show_hidden = true,
				},
			}

			-- Open parent directory in current window
			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

			-- Open parent directory in floating window
			vim.keymap.set("n", "<space>-", require("oil").toggle_float)
		end,
	},
}
