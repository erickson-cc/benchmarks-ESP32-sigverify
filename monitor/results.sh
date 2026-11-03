> relatorio_completo.txt

for log in *_benchmark.log; do
    # Isola o nome do algoritmo removendo o caminho e o sufixo
    algo=$(basename "$log" _benchmark.log)
    
    # Insere o cabeçalho de identificação do algoritmo
    echo "==========================================================================================" >> relatorio_completo.txt
    echo "ALGORITMO: $algo" >> relatorio_completo.txt
    echo "==========================================================================================" >> relatorio_completo.txt
    
    # Copia as últimas 13 linhas (tabela exata, omitindo o aviso do botão BOOT)
    tail -13 "$log" >> relatorio_completo.txt
    echo -e "\n" >> relatorio_completo.txt
done
