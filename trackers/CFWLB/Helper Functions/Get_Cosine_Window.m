function [w] = Get_Cosine_Window(dimW, step)

w1 = cos(linspace(-pi/step, pi/step, dimW(1)));
w2 = cos(linspace(-pi/step, pi/step, dimW(2)));
w = w1' * w2;

end
