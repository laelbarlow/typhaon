# Original source: https://github.com/laelbarlow/typhaon
# Licence notice: MIT License, copyright (c) 2020 Lael D. Barlow

rule parse_modelfinder:
    """
    Extract the name of the best-fit model identified by ModelFinder from the
    ModelFinder output, and write to a text file.
    """
    input:
        model_file = 'results/modelfinder/{fasta_name}.iqtree'

    output:
        model_text_file = 'results/modelfinder/{fasta_name}.txt'

    run:
        model_code = None
        with open(input.model_file) as infh:
            for i in infh:
                if i.startswith('Best-fit model according to BIC'):
                    model_code = i.rsplit(' ', 1)[1]
                    break
        assert model_code is not None
        with open(output.model_text_file, 'w') as o:
            o.write(model_code)


