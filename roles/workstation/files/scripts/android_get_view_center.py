import argparse
import logging
from xml.etree import ElementTree
from xml.etree.ElementTree import Element


def extract_pair(bounds: str, pair_no: int):
    pair_str = bounds.split('[')[pair_no + 1].split(']')[0].split(',')
    return [int(i) for i in pair_str]


def parse_bounds(bounds: str):
    return *extract_pair(bounds, 0), *extract_pair(bounds, 1)


def get_rect_center(bounds: str):
    """
    :param bounds: takes form of '[474,760][646,856]'
    :return:
    """
    x1, y1, x2, y2 = parse_bounds(bounds)
    return (x1 + x2) / 2, (y1 + y2) / 2


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-d', '--dump-path', type=str, help='Path to the dump file', default='/tmp/window_dump.xml')
    parser.add_argument('text', type=str, help='Text to match on a UI element')
    parser.add_argument('-a', '--text-add', type=str, help='Text to match on siblings to a UI element   ')
    parser.add_argument('-v', '--verbose', action='store_true')
    return parser.parse_args()


def configure_logging(args):
    if args.verbose:
        logging.basicConfig(level=logging.DEBUG)


def log_args(args):
    logging.debug(f'Arguments for this invocation:')
    for i, j in args.__dict__.items():
        logging.debug(f'{i}: {j}')


def add_parents(tree):
    """
    Took from a very creative solution here: https://stackoverflow.com/a/54943960
    """
    for i in tree:
        i.attrib['__parent__'] = tree
        add_parents(i)


def find_all_children_with_text(text_to_match, tree):
    return tree.findall(f'.//node[@text="{text_to_match}"]')


def match_text_on_siblings(match: Element, text_add_to_match: str):
    return find_all_children_with_text(text_add_to_match, match.attrib['__parent__'])


def get_printable_coordinates(i):
    return get_rect_center(i.attrib['bounds'])


def read_args(args):
    return args.dump_path, args.text, args.text_add


def main():
    args = parse_args()
    configure_logging(args)
    log_args(args)

    dump_path, text_to_match, text_add_to_match = read_args(args)

    tree = ElementTree.parse(dump_path).getroot()
    add_parents(tree)

    matches = find_all_children_with_text(text_to_match, tree)
    if len(matches) == 1:
        print(*get_printable_coordinates(matches[0]))
        return

    for i in matches:
        logging.debug(i.attrib['__parent__'].attrib['class'])
    for i in filter(lambda j: match_text_on_siblings(j, text_add_to_match), matches):
        print(*get_printable_coordinates(i))
        return

    logging.warning(f'Could not detect required view!')
    exit(2)


if __name__ == '__main__':
    main()
