json.total_geral @total_geral
json.volume_vendas do
	json.array! @volume_vendas, partial: "volume_vendas/volume_venda", as: :volume_venda
end
