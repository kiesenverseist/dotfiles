return {
	cmd = { 'nixd' },
	filetypes = { 'nix' },
	single_file_support = true,
	root_markers = { 'flake.nix', '.git' },
	settings = {
		nixd = {
			nixpkgs = {
				expr = "import <nixpkgs> { }",
			},
			formatting = {
				command = { "alejandra" },
			},
			options = {
				nixos = {
					expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.graphite.options',
				},
				home_manager = {
					expr =
					'(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."kiesen@graphite".options',
				},
			},
		},
	},
}
