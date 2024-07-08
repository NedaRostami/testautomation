import os
import re
import sys

from PIL import Image, ImageDraw, ImageFont


class MetricLogo:

    STAGING = 'STAGING'
    PR_PREFIX = 'PR'
    PASS_COLOR = '#48cd06'
    FAIL_COLOR = '#fb3535'
    METRICS_PATH = os.path.join("utils", "metrics")
    METRICS_WIDTH = 212
    METRICS_HEIGHT = 184
    PRODUCT_TOP_MARGIN = 23
    PLATFORM_FONT_SIZE = 25
    PLATFORM_TOP_MARGIN = 65
    PLATFORM_FONT_COLOR = "#979797"
    ENVIRONMENT_FONT_SIZE = 19
    ENVIRONMENT_FONT_COLOR = "black"
    ENVIRONMENT_MARGIN = (30, 104)
    SUCCESS_RATE_FONT_SIZE = 16
    SUCCESS_RATE_MARGIN = (24, 134)

    def __init__(self, product, platform, environment, success_rate, output):
        self.product = product
        self.platform = platform.replace('_', ' ')
        self.environment = environment
        self.success_rate = str(success_rate)
        self.status = 'pass' if success_rate == '100' else 'fail'
        self.output = output
        self.image = Image.new('RGBA', (self.METRICS_WIDTH, self.METRICS_HEIGHT), color='white')
        background = Image.open(self.__get_file('images', 'bg.png'))
        self.image.paste(background, (10, 10), background)

    def create_logo(self):
        self.__process_product()
        self.__process_platform()
        self.__process_environment()
        self.__process_success_rate()
        self.__process_result()
        self.image.save(self.output + '.png')

    def __process_product(self):
        product = Image.open(self.__get_file('images', self.product, 'logo.png'))
        width, _ = product.size
        box = ((self.METRICS_WIDTH - width) // 2, self.PRODUCT_TOP_MARGIN)
        self.image.paste(product, box=box)

    def __process_platform(self):
        self.platform = ' '.join(self.platform.upper())
        platform = ImageDraw.Draw(self.image)
        font_path = self.__get_file('fonts', 'debussy.ttf')
        font = ImageFont.truetype(font_path, size=self.PLATFORM_FONT_SIZE)
        width, _ = platform.textsize(self.platform, font=font)
        box = ((self.METRICS_WIDTH - width) // 2, self.PLATFORM_TOP_MARGIN)
        platform.text(box, self.platform, fill=self.PLATFORM_FONT_COLOR, font=font)

    def __process_environment(self):
        self.environment = self.environment.upper()
        environment = ImageDraw.Draw(self.image)
        font_path = self.__get_file('fonts', 'roboto-black.ttf')
        font = ImageFont.truetype(font_path, size=self.ENVIRONMENT_FONT_SIZE)
        if re.match(r'\d+', self.environment):
            background = self.__get_background(self.environment + ' ')
            environment.text(self.ENVIRONMENT_MARGIN, self.PR_PREFIX, fill=self.ENVIRONMENT_FONT_COLOR, font=font)
            width, height = self.ENVIRONMENT_MARGIN
            pr_value_margin = (width + 33, height + 1)
            self.image.paste(background, pr_value_margin, background)
            self.ENVIRONMENT_MARGIN = (width + 37, height)
            self.ENVIRONMENT_FONT_COLOR = 'white'
            width, _ = environment.textsize(self.environment, font)

        environment.text(self.ENVIRONMENT_MARGIN, self.environment, fill=self.ENVIRONMENT_FONT_COLOR, font=font)

    def __process_success_rate(self):
        self.success_rate = '%' + self.success_rate
        success_rate = ImageDraw.Draw(self.image)
        font_path = self.__get_file('fonts', 'roboto-black.ttf')
        font = ImageFont.truetype(font_path, size=self.SUCCESS_RATE_FONT_SIZE)
        color = getattr(self, self.status.upper() + '_COLOR')
        background = self.__get_background(self.success_rate, color=color)
        self.image.paste(background, (self.SUCCESS_RATE_MARGIN[0] - 2, self.SUCCESS_RATE_MARGIN[1] - 2), background)
        success_rate.text(self.SUCCESS_RATE_MARGIN, self.success_rate + '   Success', fill='black', font=font)
        success_rate.text(self.SUCCESS_RATE_MARGIN, self.success_rate, fill='white', font=font)

    def __process_result(self):
        result = Image.open(self.__get_file('images', self.status, self.status + '.png'))
        self.image.paste(result, (141, 100), result)

    def __get_file(self, *args):
        return os.path.join(self.METRICS_PATH, *args)

    def __get_background(self, text, color='black'):
        draw = ImageDraw.Draw(self.image)
        font_path = self.__get_file('fonts', 'roboto-black.ttf')
        font = ImageFont.truetype(font_path, size=self.ENVIRONMENT_FONT_SIZE)
        width, height = draw.textsize(text, font=font)
        background = self.__cornered_background(7, width, height, color=color)
        return background

    @staticmethod
    def __cornered_background(rad, width, height, color='black'):
        background = Image.new('RGB', (width + 4, height + 4), color=color)
        circle = Image.new('L', (rad * 2, rad * 2), 0)
        draw = ImageDraw.Draw(circle)
        draw.ellipse((0, 0, rad * 2, rad * 2), fill=255)
        alpha = Image.new('L', background.size, 255)
        w, h = background.size
        alpha.paste(circle.crop((0, 0, rad, rad)), (0, 0))
        alpha.paste(circle.crop((0, rad, rad, rad * 2)), (0, h - rad))
        alpha.paste(circle.crop((rad, 0, rad * 2, rad)), (w - rad, 0))
        alpha.paste(circle.crop((rad, rad, rad * 2, rad * 2)), (w - rad, h - rad))
        background.putalpha(alpha)
        return background


if __name__ == '__main__':
    product = sys.argv[1]
    platform = sys.argv[2]
    environment = sys.argv[3]
    success_rate = sys.argv[4]
    output = sys.argv[5]

    m = MetricLogo(product, platform, environment, success_rate, output)
    m.create_logo()
