Traduction française de docs.python.org
=======================================
Ce projet vise à mettre à disposition sur le site de l'afpy
une `traduction en français <http://www.afpy.org/doc/python/2.7/>`_ d'une partie de la documentation officielle de
Python, pour les curieux désirant découvrir Python mais n'ayant pas la capacité
de lire le texte en anglais.

Votre aide est la bienvenue que ce soit pour maintenir les traductions à jour,
les relire, les améliorer ou traduire de nouveaux blocs.

Comment qu'on fait pour aider à traduire ?
------------------------------------------
Pour cela récupérez les fichiers .po de la partie qui vous intéresse, d'une des
façons suivantes:

* forkez ce dépôt ;
* ou cliquez sur l'icone "ZIP".

Éditer les fichiers avec l'éditeur de votre choix:

* s'il s'agit d'un éditeur conçu spécialement pour les .po (`poedit <http://www.poedit.net/>`_,
  gted, gtranslator, lokalize, betterpoeditor, vim/emacs avec un mode PO, etc...) vous n'avez plus qu'à vous occuper du texte en français ;
* si vous utilisez un éditeur standard (**à éviter**), chaque bloc du fichier est
  constitué d'une chaine en anglais (précédée de "msgid") suivi de son
  équivalent en français ou d'une chaine vite (précédé de "msgstr"). Ce sont
  des dernières qu'il faut remplir ou améliorer.

Une fois votre contribution écrite, transmettez-la nous :

* soit par un pull-request (si vous avez fait un fork) ;
* soit en la joignant à un ticket ;
* soit par mail à la `liste traductions <http://lists.afpy.org/mailman/listinfo/traductions>`_

Quelles sont les priorités ?
----------------------------
La quantité de textes à traduire est énorme et il serait très facile de
disperser notre énergie dans des textes destinés aux utilisateurs très avancés,
il nous paraît nécessaire de fixer des priorités:

1. Avant tout et surtout : maintenir à jour les textes déjà complets
2. le tutoriel (tutorial.po)
3. le glossaire (glossary.po)
4. les bases du langage (reference.po)
5. la notice d'installation de Python (using.po)
6. la foire aux questions (faq.po)

Quand tout ceci sera traduit, il sera temps de penser au reste !

Aides à la traduction
---------------------

* Si vous hésitez sur un terme, demandez un avis sur la
  `liste traductions <http://lists.afpy.org/mailman/listinfo/traductions>`_.
* Vous pouvez consulter le `glossaire traduc.org <http://glossaire.traduc.org>`_
  qui contient des traductions consolidées de plusieur projets.
* Consultez aussi le site de
  `traduc.org <http://traduc.org>`_
  qui contient de nombreuses informations pour les traducteurs.

Uniformisation du vocabulaire
-----------------------------

Afin d'obtenir un document cohérent cette section propose une
traduction de quelques termes techniques, rappelant ainsi les anglicismes
à éviter :

 * regular expression => expression rationelle
 * library => bibliothèque
 * bound => lier
 * built-in => primitives
 * underscore => "tiret bas"
 * backslash => "antislash"
 * double quote => guillemet
 * simple quote => guillemet simple
 * mangling => "décoration de nom" ?
 * abstract data type => type abstrait
 * statement => instruction
 * \:keyword: clause => clause_ :keyword:
 * interpreter => interpréteur (Présent dans "Le Petit Robert")

.. _clause: http://www.granddictionnaire.com/ficheOqlf.aspx?Id_Fiche=8396944
