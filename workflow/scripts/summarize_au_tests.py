
import re

# Compile a regular expression to identify lines containing AU test info in
# IQTREE output files.
au_res = re.compile(r'^  \d ')

# Open output file.
with open(snakemake.output.outfile, 'w') as o:

    # Write header row.
    o.write('Dataset,Random seed,Constraint tree,' + \
            'logL,deltaL,bp-RELL,p-KH,p-SH,c-ELW,p-AU\n')

    # Get content for subsequent rows from relevant files.
    for i in snakemake.input.iqtree_output_files:

        params_and_fasta_name = i.split('iqtree_au_test/')[1].rsplit('.', 1)[0]
        fasta_name = params_and_fasta_name.split('/')[1]
        random_seed = params_and_fasta_name.split('/')[0].split('~')[1]

        # Get list of lines with results from actual tree.
        au_test_result_lines = []
        with open(i) as iqtreefh:
            section_text = \
            iqtreefh.read().split('\nUSER TREES\n----------\n')[1].split('\nTIME STAMP\n----------\n')[0]

            for l in section_text.split('\n'):
                if au_res.match(l):
                    au_test_result_lines.append(l)

        # Find corresponding file indicating the order in which tree
        # files were concatenated.
        corresponding_concat_order_file = None
        for j in snakemake.input.concat_order_files:
            if params_and_fasta_name in j:
                corresponding_concat_order_file = j
                break
        assert corresponding_concat_order_file is not None

        # Get list of constraint tree filenames. 
        constraint_tree_filenames = []
        with open(corresponding_concat_order_file) as concatfh:
            for l in concatfh:
                if not l.startswith('\n'):

                    constraint_tree_filename = '-'
                    if "constrained_ml_searches" in l:
                        constraint_tree_filename = \
                        os.path.basename(l.strip()).replace('.tre.treefile', '.tre')

                    constraint_tree_filenames.append(constraint_tree_filename)

        # Bring together relevant information for each row.
        for constr_tree, au_res_row in zip(constraint_tree_filenames, au_test_result_lines):

            # Parse AU test result lines.
            s = au_res_row.replace('+', '').split()

            # Write to output file.
            components = [fasta_name,
                          random_seed,
                          constr_tree,
                          s[1],
                          s[2],
                          s[3],
                          s[4],
                          s[5],
                          s[6],
                          s[7]
                          ]
            o.write(','.join(components) + '\n')
