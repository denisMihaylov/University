def complement(f)
  -> (*args) { not f.call(*args) }
end

def compose(f, g)
  -> (*args) do
    args_for_f = g.call(*args)
    f.call(*args_for_f)
  end
end
