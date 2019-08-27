select extract(epoch from now() + '5 minutes'::interval) :: integer;
So this epoch value = 1566880492.
