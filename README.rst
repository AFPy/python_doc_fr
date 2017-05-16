Traduction française de docs.python.org
=======================================

**/!\ Pour vous simplifier les merge futurs dû au récent découpage des fichiers, faites nous une PR, on s'occupe du merge.**

Ce projet vise à mettre à disposition sur le site de l'afpy une
`traduction en français <http://www.afpy.org/doc/python/>`_ de la
documentation officielle de Python.

Votre aide est la bienvenue que ce soit pour maintenir les traductions
à jour, les relire, les améliorer ou traduire de nouveaux blocs.

Progression de la traduction :

============  =====  =====  =====
          ..    2.7    3.5    3.6
============  =====  =====  =====
    about.po   100%   100%   100%
     bugs.po   100%   100%   100%
       c-api     9%    12%    11%
 contents.po   100%   100%   100%
copyright.po   100%   100%   100%
distributing   100%   100%   100%
   distutils    13%    13%    33%
   extending    21%    24%    24%
         faq    29%    32%    32%
 glossary.po    85%   100%   100%
       howto     6%     6%     6%
     install    45%    46%    43%
  installing   100%   100%    66%
     library    16%    20%    19%
  license.po   100%   100%   100%
   reference     4%     5%     5%
   sphinx.po   100%   100%    93%
    tutorial    97%   100%    98%
       using    31%    21%    19%
    whatsnew     6%    41%     7%
     ~total~    18%    25%    19%
============  =====  =====  =====


Comment qu'on fait pour aider à traduire ?
------------------------------------------

* Soit sur [transifex/python-doc](https://www.transifex.com/python-doc/),
  et le reste de cette section ne vous concerne pas.
* Soit "à la main" : pour cela récupérez les fichiers *.po* de la partie qui vous intéresse,

  * Soit via `Download ZIP` (si `git` n'est pas encore fait pour vous),
  * Soit :

  ::

    $ git clone https://github.com/AFPy/python_doc_fr.git # Ou votre fork
    $ cd python_doc_fr
    $ PATH=$PATH:$HOME/.local/bin/ # Vous devriez mettre ça dans votre ~/.bashrc
    $ make # Génère la doc en HTML chez vous
    $ x-www-browser gen/src/3.6/Doc/build/html/index.html

Éditer les fichiers avec l'éditeur de votre choix, il en existe beaucoup :

* Le classique, fortement conseillé: `poedit <http://www.poedit.net/>`_
* gted
* gtranslator
* lokalize
* betterpoeditor
* vim ou emacs avec un mode PO
* Vé sur Android
* Probablement d'autres :)

Puis vous n'avez plus qu'à vous occuper du texte en français.

Une fois votre contribution écrite, transmettez-la nous :

* Soit par un pull-request (si vous avez fait un fork du dépot)
* Soit en la joignant à un `ticket github <https://github.com/AFPy/python_doc_fr/issues>`_
* Soit par mail à la `liste traductions <http://lists.afpy.org/mailman/listinfo/traductions>`_

Quoi traduire, ne pas traduire, quel style ?

* Nous ne travaillons que sur la dernière version de Python,
  lorsqu'elle sera entièrement traduite, nous attaquerons le reste, en
  attendant, nous répliquons notre travail en utilisant
  ``./scripts/replicate_translations.py``
* Attention, ``install.po`` est à peu près inutile, aucun (?) lien ne
  pointe dessus.
* Pas de traduction pour ``licence.po``,
  `voir le ticket #30 <https://github.com/AFPy/python_doc_fr/issues/30>`.
* Les référence *:ref:`...`*, *:term:`...`* ne sont pas à traduire
* Les mots anglais, nous les mettons en *italique* (en les entourant
  d'étoiles dans la traduction).
* Les "::" de fin de paragraphes se traduisent " : ::" en français,
  pour créer l'espace précédent le ":" du français.

Norme et style
--------------

Si vous utilisez git et faites des pull requests, cette section est
importante, pour les mails et les tickets, on s'en occupera pour vous.

Afin de ne pas générer des diff illisibles remplis de plus de
différences de norme que de différences de texte, autremment dit, afin
d'obtenir un historique git lisible, et des merge faciles, nous
utilisons tous la même norme.

Actuellement, nous utilisons la norme proposée par *msgcat*, vous
pouvez donc utiliser cette ligne pour remettre vos traductions en forme:

    ./scripts/fix_style.py

Quelles sont les priorités ?
----------------------------
La quantité de textes à traduire est énorme et il serait très facile de
disperser notre énergie dans des textes destinés aux utilisateurs très avancés,
il nous paraît nécessaire de fixer des priorités:

1. Avant tout et surtout : maintenir les textes déjà complets (tutorial.po, glossary.po).
3. les bases du langage (reference.po)
4. la notice d'installation de Python (using.po)
5. la foire aux questions (faq.po)

Aides à la traduction
---------------------

* `Le grand dictionnaire terminologique <http://gdt.oqlf.gouv.qc.ca/>`_
* Le chan IRC `#python-fr <irc.lc/freenode/python-fr>`_ sur freenode
* La `liste traductions <http://lists.afpy.org/mailman/listinfo/traductions>`_
* Vous pouvez consulter le `glossaire traduc.org <http://glossaire.traduc.org>`_
  qui contient des traductions consolidées de plusieur projets.
* Consultez aussi le site de `traduc.org <http://traduc.org>`_
  qui contient de nombreuses informations pour les traducteurs.
* glossary.po tout simplement, ou
  `le glossaire traduit <http://www.afpy.org/doc/python/3.6/glossary.html>`_

Uniformisation du vocabulaire
-----------------------------

Afin d'obtenir un document cohérent cette section propose une
traduction de quelques termes techniques, rappelant ainsi les
anglicismes à éviter, ce n'est qu'une proposition discutable (ouvrez
un ticket si vous n'êtes pas d'acord) :

* -like => -compatible (Pas toujours élégant, voir
  `ce ticket <https://github.com/soulaklabs/bitoduc.fr/issues/86>`_)
* abstract data type => type abstrait
* argument => argument (et non paramètre (qui est la traduction de parameter))
* backslash => antislash ?
* bound => lier
* bug => bug (Bogue étant déjà pris par la châtaigne…)
* débugging => débogage (en contradiction avec le précédent ?)
* built-in => primitives, natives, interne, intégré
* double quote => guillemet
* identifier => identifiant
* immutable => immuable
* interpreter => interpréteur
* library => bibliothèque
* list compréhension => compréhension de liste
* mutable => variable
* parameter => paramètre
* prompt => invite
* regular expression => expression rationnelle
* simple quote => guillemet simple
* socket => socket ("Je veux mon niveau ! Chausette ! Chausette !")
* statement => instruction
* underscore => tiret bas ?
* little-endian, big-endian: `petit-boutise, gros-boutiste
  <https://fr.wikipedia.org/wiki/Endianness>`_

Comment générer la doc localement ?
-----------------------------------

Vous aurez besoin de ``pdflatex``, ``svn``, ``markdown``, et ``gettext``, je
vous conseille un : ::

  apt-get install texlive-full subversion markdown gettext python3-pip


La doc de Python est générée par un Makefile, nous utilisons aussi un
Makefile lançant le leur.

Pour faire simple, pour générer le HTML de la dernière version dans
`www/` faite juste : ::

  $ pip -q install --user -U -r scripts/requirements.txt
  $ make

Plus compliqué, pour générer une version spécifique : ::

  $ make RELEASE=2.7

Ou toutes les releases : ::

  $ make build_all

Ou générer aussi le Latex et les PDF : ::

  $ make MODE=autobuild-stable

Donc, pour tout mettre en prod, attention ça prend du temps : ::

  $ make build_all MODE=autobuild-stable

Regardez aussi le Makefile lui même pour toutes les autres options et
détails.


Comment on met à jour les *.pot*, et comment on les merge dans les *.po* ?
--------------------------------------------------------------------------

Le Makefile le permet via : ::

  $ make msgmerge

Ou pour une autre version : ::

  $ make msgmerge RELEASE=2.7

Ou pour toutes les versions d'un coup : ::

  $ make mermerge_all

Comment ça part sur afpy.org/python ?
-------------------------------------

Tout peut être amené à bouger, mais pour le moment, rien n'est executé
côté serveur, le protocole actuel pour mettre à jour la prod est donc
de lancer : ::

  $ make all_releases
  $ make index_page
  $ rsync -az www/ afpy.org:/home/mandark/www/

tout simplement.

Rendre les ``git show`` lisibles
--------------------------------

On vous a préparé un script, ``scripts/podiff``, et on a configuré
``.gitattributes``, il ne vous reste plus qu'a executer:

    git config diff.podiff.textconv scripts/podiff

et vos ``git show`` deviendront un peu plus lisibles.

Transifex synchronisation
-------------------------

To configure:

 - python3 -m pip install transifex-client
 - tx init
 - ./scripts/gen_tx_config.py .tx/config

To pull and push use ``make txpull`` and ``make txpush``.
