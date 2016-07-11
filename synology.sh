# Valores probados para dos Synology con cajones de expansión
# update to use more RAM (Stripe Cache Size) and higher lower bound (speed_limit_min)
echo 50000 >/proc/sys/dev/raid/speed_limit_mit
# Bumping to 32768 resulted in ~512MB RAM increase, and hangs up if we don't have resources available, and the process is long in time.
echo 16384 >/sys/block/md2/md/stripe_cache_size

# revert the settings after expansion has finished
echo 10000 > /proc/sys/dev/raid/speed_limit_min
echo 4096 > /sys/block/md2/md/stripe_cache_size
