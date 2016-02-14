Traduction française de docs.python.org
=======================================

Ce projet vise à mettre à disposition sur le site de l'afpy une
`traduction en français <http://www.afpy.org/doc/python/>`_ de la
documentation officielle de Python.

Votre aide est la bienvenue que ce soit pour maintenir les traductions
à jour, les relire, les améliorer ou traduire de nouveaux blocs.

Progression de la traduction:

=============== ====== ====== ====== ====== ======
        version    2.7    3.2    3.3    3.4    3.5
--------------- ------ ------ ------ ------ ------
       contents   100%   100%   100%   100%   100%
      copyright    87%    87%    87%    87%   100%
          about   100%   100%   100%   100%   100%
           bugs    76%    71%    76%    90%   100%
   distributing   100%    N/A    N/A   100%   100%
         sphinx   100%   100%   100%   100%   100%
     installing    84%    N/A    N/A   100%   100%
        license    82%    67%    66%    68%   100%
        install    22%    23%    23%    22%    22%
       glossary    81%    94%    97%    98%   100%
      extending    21%    21%    22%    23%    25%
          using    21%    23%    18%    17%    12%
       tutorial    95%    90%    96%    99%   100%
            faq    26%    27%    27%    27%    29%
      distutils    11%    10%    10%    10%    10%
      reference     2%     3%     2%     3%     3%
          howto     2%     2%     2%     2%     3%
          c-api     7%     8%     9%     8%    10%
       whatsnew     4%     4%     4%     3%     6%
        library    10%    12%    11%    11%    12%
      **TOTAL**    13%    14%    12%    12%    13%
=============== ====== ====== ====== ====== ======

Comment qu'on fait pour aider à traduire ?
------------------------------------------

Pour cela récupérez les fichiers *.po* de la partie qui vous intéresse,
d'une des façons suivantes:

* forkez ce dépôt (conseillée)
* cliquez sur l'icone "Download ZIP"

Éditer les fichiers avec l'éditeur de votre choix, il en existe beaucoup:

* Le classique: `poedit <http://www.poedit.net/>`_
* gted
* gtranslator
* lokalize
* betterpoeditor
* vim ou emacs avec un mode PO
* Vé sur Android
* Probablement d'autres :)

Puis vous n'avez plus qu'à vous occuper du texte en français.

Une fois votre contribution écrite, transmettez-la nous :

* soit par un pull-request (si vous avez fait un fork du dépot)
* soit en la joignant à un `ticket github <https://github.com/AFPy/python_doc_fr/issues>`_
* soit par mail à la `liste traductions <http://lists.afpy.org/mailman/listinfo/traductions>`_

Quoi traduire, ne pas traduire, quel style ?

* Nous ne travaillons que sur la dernière version de Python,
  lorsqu'elle sera entièrement traduite, nous attaquerons le reste, en
  attendant, nous répliquons notre travail en utilisant
  ``./scripts/replicate_translations.py``
* Attention, ``install.po`` est à peu près inutile, aucun (?) lien ne
  pointe dessus.
* Pour le moment, nous laissons à part ``licence.po``,
  `voir le ticket #30 <https://github.com/AFPy/python_doc_fr/issues/30>`.
* Les référence *:ref:`...`* ne sont pas à traduire
* Les références *:term:`...`* sont à traduire, leur traduction se
  trouve dans *glossary.po*.
* Les mots anglais, nous les mettons en *italique* (en les entourant
  d'étoiles dans la traduction).
* Les "::" de fin de paragraphes se traduisent " : ::" en français,
  pour créer l'espace précédent le ":" du français.

Norme et style
--------------

Si vous utilisez git et faites des pull requests, cette section est
importante, pour les mails et les tickets, on s'en occupera pur vous.

Afin de ne pas générer des diff illisibles remplis de plus de
différences de norme que de différences de texte, autremment dit, afin
d'obtenir un historique git lisible, et des merge faciles, nous
utilisons tous la même norme.

Actuellement, nous utilisons la norme proposée par *msgcat*, vous
pouvez donc utiliser cette ligne pour remettre vos traductions en forme:

    ./scripts/fix_style.sh

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
  `le glossaire traduit <http://www.afpy.org/doc/python/3.5/glossary.html>`_

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
* backslash => antislash
* bound => lier
* bug => bug (Bogue étant déjà pris par la châtaigne…)
* débugging => débogage (en contradiction avec le précédent ?)
* built-in => primitives, interne
* double quote => guillemet
* identifier => identifiant
* immutable => immuable
* interpreter => interpréteur
* library => bibliothèque
* list compréhension => compréhension de liste
* little/big endian => `petit-boutiste et gros-boutiste <https://fr.wikipedia.org/wiki/Les_Voyages_de_Gulliver#Voyage_.C3.A0_Lilliput>`_
* mutable => variable
* parameter => paramètre
* prompt => invite
* regular expression => expression rationnelle
* simple quote => guillemet simple
* socket => socket ("Je veux mon niveau ! Chausette ! Chausette !")
* statement => instruction
* underscore => tiret bas

Comment générer la doc localement ?
-----------------------------------

Un script, ``./scripts/build.sh`` permet de générer la doc, il
s'occupera pour vous de rappatrier un clone de *cpython*, de le
configurer, d'y appliquer éventuellement quelques patches (en
attendant qu'ils soient mergés upstream), et vous vous retrouvez si
tout va bien avec la doc dans ``www/``.

Pour générer une autre version que la dernière, la passer en
paramètre, comme : ``./scripts/build.sh 3.2``.

Comment on met à jour les *.pot*, et comment on les merge dans les *.po* ?
--------------------------------------------------------------------------

Un script, ``./scripts/sync.sh`` permet de récupérer ou mettre à jour
un clone de *cpython* dans ``gen/``, il y fera passer un ``xgettext``,
fera les bon msgmerge qui vont bien, sur la dernière version par
défaut, lancez donc plutôt:

    for V in 2.7 3.2 3.3 3.4 3.5; do ./scripts/sync.sh $V; done

Comment ça part sur afpy.org/python ?
-------------------------------------

Tout peut être amené à bouger, mais pour le moment, rien n'est executé
server side, le protocole actuel pour mettre à jour la prod est donc de lancer

    for V in 2.7 3.2 3.3 3.4 3.5; do ./scripts/build.sh $V; done
    rsync -az www/ afpy.org:/home/mandark/www/

tout simplement.
