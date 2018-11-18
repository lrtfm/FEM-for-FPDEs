data = 1:40;
data = reshape(data, 8, 5);

Print(1, data, 'OutputFormat', 'Plain')
Print(1, data,'Head',{'M', 'L1', 'L2', 'L3', 'L4'},'OutputFormat', 'TPlain')
Print(1, data,'OutputFormat', 'Latex')
Print(1, data, 'Head',{'M', 'L1', 'L2', 'L3', 'L4'}, 'OutputFormat', 'TLatex')
Head = {'M', 'L1', 'L2', 'L3', 'L4'};
OutputFormat = 'TLatex';
DataFormat = {'%10g', '%10.2e', '%10g', '%10.4f', '%10.2f'};
Print(1, data,'Head',Head,'OutputFormat', OutputFormat, 'DataFormat', DataFormat)
