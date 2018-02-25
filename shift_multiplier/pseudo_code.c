a = a_in;
b = b_in;
n = WIDTH;
p = 0;
op: if b(0) = 1
{
  p = p + a;
}

a = a << 1;
b = b >> 1;
n = n - 1;
if n != 0
{
  goto op;
}
r_out = p;
