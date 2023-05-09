from manim import *

class Interleave(Scene):
    def construct(self):
        x = Text("x: 23", color = GREEN_A)
        y = Text("y: 42", color = RED_A)
        y.next_to(x, direction=DOWN)
        self.add(x)
        self.play(Create(x))
        self.wait(2)

        xbin = Text("0 0 0 1 0 1 1 1", font = "Monospace", color = GREEN_A)
        self.play(Transform(x, xbin))
        self.wait(2)
        self.remove(x)
        self.add(y)
        self.play(Create(y))
        self.wait(1)

        ybin = Text("឴ 0 0 1 0 1 0 1 0", color = RED_A, font = "Monospace")
        ybin.next_to(xbin, direction = DOWN)
        self.play(Transform(y, ybin))
        self.remove(y)
        self.add(ybin)
        self.wait(2)

        self.play(Create(xbin))
        
        # animate interleaving 
        xbin.generate_target()
        ybin.generate_target()
        ybin.target.move_into_position()
        self.wait(2)
        self.play(MoveToTarget(ybin))
        self.wait(2)

        self.remove(xbin, ybin)

        # # Define the colors
        # red = "#FF0000"  # Red color
        # white = "#FFFFFF"  # White color
        # text_str = "1101000010100110110101001000001001101111000101011011110011010001"

        # # Create a Text object to display the text
        # text = Text(text_str, font_size = 36, color=red).scale(0.5)

        # # Set initial position for the first text chunk
        # text.next_to(ORIGIN, LEFT)

        # # Split the text into chunks of 5 characters
        # text_chunks = [text[i:i+5] for i in range(0, len(text_str), 5)]

        # # Loop through the text chunks and alternate the colors
        # for i, chunk in enumerate(text_chunks):
        #     color = white if i % 2 == 0 else red
        #     chunk.set_color(color)
        #     if i == 0:
        #         self.play(Write(chunk), run_time=0.25)
        #     else:
        #         self.play(chunk.animate.next_to(text_chunks[i-1], RIGHT), run_time=0.25)

        # self.wait(2)
            
# class SquareAnimation(Scene):
#     def construct(self):

#         square = Square(side_length = 7)
#         self.add(square)
#         self.play(Create(square))

#         pnt = Dot([0.9, 1, 0])
#         self.add(pnt)
#         self.play(Create(pnt))



