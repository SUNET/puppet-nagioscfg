#!/usr/bin/env python3

import os
import yaml
import re

def iteritems(d):
    return iter(d.items())

def _all_hosts():
   return list(filter(lambda fn: '.' in fn and not fn.startswith('.') and os.path.isdir("/var/cache/cosmos/repo/" + fn),os.listdir("/var/cache/cosmos/repo")))

def _load_db():
   rules = dict()
   rules_file = "/etc/puppet/cosmos-rules.yaml";
   if os.path.exists(rules_file):
      with open(rules_file) as fd:
        # Supress warnings from modern versions of PyYAML
        #
        # File
        # "/etc/puppet/cosmos-modules/nagioscfg/facts.d/nagioscfg-groups-from-cosmos.py",
        # line 18, in _load_db rules.update(yaml.load(fd,
        # Loader=yaml.FullLoader)) AttributeError: module 'yaml' has no
        # attribute 'FullLoader'
        #
        # Loader was introduced in PyYAML 5.1 which is not available on all our
        # machines.
        try:
            rules.update(yaml.load(fd, Loader=yaml.FullLoader))
        except AttributeError:
            rules.update(yaml.load(fd))

   all_hosts = _all_hosts()

   members = dict()
   for node_name in all_hosts:
      for reg,cls in iteritems(rules):
         if re.match(reg,node_name):
            for cls_name in cls.keys():
               h = members.get(cls_name,[])
               h.append(node_name)
               members[cls_name] = h
   members['all'] = all_hosts

   for node_name in all_hosts:
      node_classes = dict()
      for reg,cls in iteritems(rules):
         if re.match(reg,node_name):
            node_classes.update(cls)

   # Sort member lists for a more easy to read diff
   for cls in members.keys():
       members[cls].sort()

   return dict(configured_hosts_in_cosmos=members)

_db = None
def cosmos_db():
   global _db
   if _db is None:
      _db = _load_db()
   return _db

if __name__ == '__main__':
   print(yaml.dump(cosmos_db(), default_flow_style=None))
