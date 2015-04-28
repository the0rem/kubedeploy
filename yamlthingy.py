"""
YAML Templating Thingy
-- Tim Dousset 2015-04-28
"""

import re
import os
import sys
import argparse
import yaml
# from yaml import load, dump
# from yaml import Loader, Dumper


class YAMLThingy(object):
  def __init__(self, templatefile, marker, contentfile, outputfile):

    self._tf = file(templatefile, 'r')
    try:
      yaml.load(self._tf)
    except yaml.YAMLError, exc:
      print "Could not parse templatefile YAML"
      if hasattr(exc, 'problem_mark'):
        mark = exc.problem_mark
        print "Error position: (%s:%s)" % (mark.line+1, mark.column+1)
      sys.exit(1)
    print "templatefile %s is validated." % (templatefile, )

    self._cf = file(contentfile, 'r')
    try:
      yaml.load(self._cf)
    except yaml.YAMLError, exc:
      print "Could not parse contentfile YAML"
      if hasattr(exc, 'problem_mark'):
        mark = exc.problem_mark
        print "Error position: (%s:%s)" % (mark.line+1, mark.column+1)
      sys.exit(1)
    print "contentfile %s is validated." % (contentfile, )

    # Init the output file
    self._of = file(outputfile, 'w')

    # Verify that the pattern occurs.
    found = False
    self._tf.seek(0)
    for line in self._tf.readlines():
      self._of.write(line)
      if re.match('.*%s.*' % (marker, ), line) is not None:
        found = True
        indent = ''
        indentmatch = re.match('(\s+)', line)
        if indentmatch is not None:
          indent = indentmatch.group(0)
        self._cf.seek(0)
        for contentline in self._cf.readlines():
          newline = '%s  %s' % (indent, contentline)
          self._of.write(newline)
    self._of.close()

    if not found:
      print "Did not find the marker '%s' within the template file!" % (marker, )

if __name__ == "__main__":
  parser = argparse.ArgumentParser()
  parser.add_argument('--templatefile', dest='templatefile', default=None,
                      help='Template YAML file.')
  parser.add_argument('--marker', dest='marker', default=None,
                      help='Marker to position contents of contentfile within templatefile')
  parser.add_argument('--contentfile', dest='contentfile', default=None,
                      help='File containing YAML data to inject.')
  parser.add_argument('--outputfile', dest='outputfile', default=None,
                      help='File to write final product out to.')
  args = parser.parse_args()

  if args.templatefile is not None:
    if not os.path.isfile(args.templatefile):
      print "Could not find the templatefile you specified."
      print args.templatefile
      sys.exit(1)
  else:
    print "You must supply a templatefile (--templatefile)"
    parser.print_help()
    sys.exit(1)

  if args.marker is None or len(args.marker) == 0:
    print "You must supply a marker included in the template to show where contentfile should be injected."
    sys.exit(1)

  if args.contentfile is not None:
    if not os.path.isfile(args.contentfile):
      print "Could not find the contentfile you specified."
      print args.contentfile
      sys.exit(1)
  else:
    print "You must supply a contentfile (--contentfile)"
    parser.print_help()
    sys.exit(1)

  if args.outputfile is None:
    print "You must supply a outputfile (--outputfile)"
    parser.print_help()
    sys.exit(1)

  try:
    thingy = YAMLThingy(args.templatefile, args.marker, args.contentfile, args.outputfile)
  except KeyboardInterrupt:
    print 'Interrupted. Bailing...'
    sys.exit(1)
