Traduction française de docs.python.org
=======================================

Ce projet vise à mettre à disposition sur le site de l'afpy une
`traduction en français <http://www.afpy.org/doc/python/>`_ d'une
partie de la documentation officielle de Python, pour les curieux
désirant découvrir Python mais n'ayant pas la capacité de lire le
texte en anglais.

Votre aide est la bienvenue que ce soit pour maintenir les traductions
à jour, les relire, les améliorer ou traduire de nouveaux blocs.

Comment qu'on fait pour aider à traduire ?
------------------------------------------

Pour cela récupérez les fichiers .po de la partie qui vous intéresse,
d'une des façons suivantes:

* forkez ce dépôt ;
* ou cliquez sur l'icone "ZIP".

Éditer les fichiers avec l'éditeur de votre choix:

* S'il s'agit d'un éditeur conçu spécialement pour les .po (`poedit
  <http://www.poedit.net/>`_, gted, gtranslator, lokalize,
  betterpoeditor, vim/emacs avec un mode PO, Vé sur Android, etc...)
  vous n'avez plus qu'à vous occuper du texte en français ;

* Si vous utilisez un éditeur standard, chaque bloc du fichier est
  constitué d'une chaine en anglais (précédée de "msgid") suivi de son
  équivalent en français ou d'une chaine vite (précédé de
  "msgstr"). Ce sont des dernières qu'il faut remplir ou améliorer.
  Consultez la section "Norme" puisque votre éditeur ne l'appliquera
  forcément pas pour vous.

Une fois votre contribution écrite, transmettez-la nous :

* soit par un pull-request (si vous avez fait un fork) ;
* soit en la joignant à un `ticket github<https://github.com/AFPy/python_doc_fr/issues>` ;
* soit par mail à la `liste traductions <http://lists.afpy.org/mailman/listinfo/traductions>`_

Norme
-----

Afin de ne pas générer des diff illisibles remplis de plus de
différences de norme que de différences de texte, autremment dit, afin
d'obtenir un historique git lisible, et des merge faciles, nous
devrions tous utiliser strictement la même norme.

Ainsi, si vous utilisez un éditeur de texte pour faire vos
traductions, ce n'est peut être pas évident d'appliquer strictement
une norme à la main, vous pouvez donc utiliser:

    for po in *.po; do echo $po; tac $po | tac | msgcat - -o $po; done

autremment dit, utiliser msgcat pour réecrire proprement votre fichier
après avoir mis les mains dedans. (l'astuce tac|tac c'est pour lire
entièrement le fichier avant de l'écrire).

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
* Consultez aussi le site de `traduc.org <http://traduc.org>`_
  qui contient de nombreuses informations pour les traducteurs.
* `Le grand dictionnaire terminologique` <http://gdt.oqlf.gouv.qc.ca/>`_

Uniformisation du vocabulaire
-----------------------------

Afin d'obtenir un document cohérent cette section propose une
traduction de quelques termes techniques, rappelant ainsi les
anglicismes à éviter, ce n'est qu'une proposition discutable (ouvrez
un ticket si vous n'êtes pas d'acord) :

 * abstract data type => type abstrait
 * backslash => antislash
 * bound => lier
 * built-in => primitives, interne
 * double quote => guillemet
 * identifier => identifiant
 * immutable => immuable
 * interpreter => interpréteur
 * library => bibliothèque
 * list compréhension => compréhension de liste
 * mutable => variable
 * prompt => invite
 * regular expression => expression rationelle
 * simple quote => guillemet simple
 * statement => instruction
 * underscore => tiret bas

.. _clause: http://www.granddictionnaire.com/ficheOqlf.aspx?Id_Fiche=8396944
