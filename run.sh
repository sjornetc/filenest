#!/bin/bash
set -e

show_help() {
cat <<'EOF'
Usage: filenest [OPTIONS] [PATH]

Creates or deletes a folder and file structure simulating a house.

Options:
  -b, --build       Build the structure
  -d, --delete      Delete the structure
  -r, --replace     If the target folder already exists, delete it and rebuild
  -h, --help        Show this help and exit

Arguments:
  PATH              Root folder where the structure will be created (default:
                    ./)

If no actions are given, defaults to -br (build & replace).
To run directly from the GitHub repository, use
  bash <(curl -s https://raw.githubusercontent.com/sjornetc/filenest/main/run.sh)
    [OPTIONS] [PATH]


Examples:
  filenest -b                  → build the house in ./ (error if already exists)
  filenest -br ~/projects/home → rebuild the house in ~/projects/home
  filenest -d                  → delete ./
EOF
}

ARGS=$(getopt -o bdrh -l build,delete,replace,help -- "$@") || {
  echo "filenest: Invalid parameters. Use -h for help." >&2
  exit 1
}
eval set -- "$ARGS"

build=false
delete=false
replace=false
root=""

while true; do
  case "$1" in
    -b|--build) build=true; shift ;;
    -d|--delete) delete=true; shift ;;
    -r|--replace) replace=true; shift ;;
    -h|--help) show_help; exit 0 ;;
    --) shift; break ;;
    *) echo "filenest: Unknown option: $1" >&2; exit 1 ;;
  esac
done

if [[ $# -gt 1 ]]; then
  echo "filenest: Only one path argument is allowed." >&2
  echo "Use -h for help." >&2
  exit 1
elif [[ -n "$1" ]]; then
  root="${1%/}/"
else
  root="./"
fi



##############
## Settings ##
##############

casa="casa"
rooms_dir=".rooms/"



rooms="$root/$rooms_dir/"


###########
## Setup ##
###########


if "$delete"; then
  dest=$(readlink -f -- "${root}/${casa}" 2>/dev/null) || dest=""
  prefix="$(realpath -- "$root")/"
#  if [[ -L "$root/casa" \
#    &&  -n "$dest" \
#    &&  "$dest" == "$prefix"* \
#    &&  "${dest#"$prefix"}" =~ ^[^/]+/rebedor/?$ ]]; then
#      rm -rf -- "$(dirname -- "$dest")"
#      rm -f -- "$root/casa"
#      exit 0
  if [[ -L "${root}/${casa}" || -d "${root}/${rooms_dir}" ]]; then
      rm -rf -- "${root}/${rooms_dir}"
      rm -f -- "${root}/${casa}"
      exit
  else
      echo "filenest: No valid 'casa' was found in '$root'." >&2
      exit 1
  fi
fi

if "$build"; then
  if [[ -e "$root/${casa}" ]]; then
    if "$replace"; then
      if [[ -L "$root/${casa}" ]]; then
        dest=$(readlink -f -- "$root/casa" 2>/dev/null) || dest=""
        if [[ -n "$dest" ]]; then
          rm -rf -- "$(dirname -- "$dest")"
        fi
        rm -f -- "${root}/${casa}"
        rm -rf -- "${root}/${rooms_dir}"
      else
        echo "filenest: '$root/casa' already exists and it is not a filenest 'casa'"
        exit 1
      fi
    else
      echo "filenest: '$root/casa' already exists. Use -r to replace it."
      exit 1
    fi
  else
    mkdir -p "$root"
  fi
else
  mkdir -p "$root"
fi


##############
## Building ##
##############

mkdir "$rooms"




##########
## Hall ##
##########

mkdir "$rooms/rebedor"

echo "🪞" > "$rooms/rebedor/mirall.txt"
echo "🏙" > "$rooms/rebedor/quadre_ciutat.txt"

echo "echo -n \"🕰 \";date -u +%I:%M:%S" > "$rooms/rebedor/rellotge_de_paret.sh"
chmod +x "$rooms/rebedor/rellotge_de_paret.sh"

# Cadira
mkdir "$rooms/rebedor/cadira"

# Test
mkdir "$rooms/rebedor/test"
echo "🪴" > "$rooms/rebedor/test/planta_poto.txt"

# Quadre elèctric
mkdir "$rooms/rebedor/quadre_electric"
cat <<'EOF' > "$rooms/rebedor/quadre_electric/rm.sh"
#!/bin/bash
# Go to "casa" mother directory.
cd "$(dirname -- $(dirname -- $(dirname -- $(dirname -- $(realpath -- $0)))))"
bash <(curl -s https://raw.githubusercontent.com/sjornetc/filenest/main/run.sh) -d
EOF
chmod +x "$rooms/rebedor/quadre_electric/rm.sh"

cat <<'EOF' > "$rooms/rebedor/quadre_electric/rebuild.sh"
#!/bin/bash
casa_path="$(dirname -- $(dirname -- $(dirname -- $(dirname -- $(realpath -- $0)))))"
echo $casa_path
bash <(curl -s https://raw.githubusercontent.com/sjornetc/filenest/main/run.sh) -br $casa_path
EOF
chmod +x "$rooms/rebedor/quadre_electric/rebuild.sh"


# Penja-robes
mkdir       "$rooms/rebedor/penjarobes"
echo "🧥" > "$rooms/rebedor/penjarobes/jaqueta_negra.txt"
echo "🧥" > "$rooms/rebedor/penjarobes/jaqueta_marro.txt"
echo "🧥" > "$rooms/rebedor/penjarobes/jaqueta_blava.txt"
echo "👒" > "$rooms/rebedor/penjarobes/barret_negre.txt"
echo "👒" > "$rooms/rebedor/penjarobes/barret_vermell.txt"
echo "👒" > "$rooms/rebedor/penjarobes/barret_blau.txt"
mkdir "$rooms/rebedor/penjarobes/bossa_marro"
echo "🌂" > "$rooms/rebedor/penjarobes/paraigues_blau.txt"
echo "🌂" > "$rooms/rebedor/penjarobes/paraigues_negre.txt"


# Tauleta
mkdir "$rooms/rebedor/tauleta"

echo "🔑" > "$rooms/rebedor/tauleta/claus.txt"
echo "💁‍♀️" > "$rooms/rebedor/tauleta/foto_alice.txt"
echo "🧑‍🦱" > "$rooms/rebedor/tauleta/foto_bob.txt"
echo "👧" > "$rooms/rebedor/tauleta/foto_clea.txt"
echo "👩‍👧" > "$rooms/rebedor/tauleta/foto_alice_clea.txt"
echo "💃" > "$rooms/rebedor/tauleta/figureta_flamenca.txt"
echo "💡" > "$rooms/rebedor/tauleta/llum_lampareta.txt"


# Calaix 0
mkdir "$rooms/rebedor/tauleta/calaix_0"

for y in $(seq 16 25)
do
  for m in $(seq -f "%02g" 1 12)
  do
    echo "\
Factura Elèctrica
================================================================
Clienta: Alice
Número factura: F$m$y-$RANDOM-$RANDOM
Número de compte: EB-2547-02
Data de lectura: 01/$m/20$y
----------------------------------------------------------------
Lectura anterior:   $((90+$RANDOM%40)),$(($RANDOM%999)) kWh
Consum:             $((90+$RANDOM%40)),$(($RANDOM%999)) kWh
Preu mitjà energia: €0.178 / kWh
Cost energia:       €$((90+$RANDOM%40)),$(($RANDOM%99))
Càrrec fix:         €$((2+$RANDOM%6)),$(($RANDOM%99))
Altres càrrecs:     €$((12+$RANDOM%6)),$(($RANDOM%99))" > "$rooms/rebedor/tauleta/calaix_0/factura_electrica_$y-$m.txt"

    echo "\
Factura de l'Aigua
================================================================
Clienta: Alice
Número factura: F$m$y-$RANDOM-$RANDOM
Número de compte: EB-2547-02
Data de lectura: 01/$m/20$y
----------------------------------------------------------------
Lectura anterior:   $((90+$RANDOM%40)),$(($RANDOM%999)) l
Consum:             $((90+$RANDOM%40)),$(($RANDOM%999)) l
Preu mitjà:         €0.178 / l
Cost                €$((40+$RANDOM%40)),$(($RANDOM%99))
Càrrec fix:         €$((2+$RANDOM%6)),$(($RANDOM%99))
Altres càrrecs:     €$((12+$RANDOM%6)),$(($RANDOM%99))" > "$rooms/rebedor/tauleta/calaix_0/factura_aigua_$y-$m.txt"
  done
echo "\
Contracte de l'assegurança
----------------------------------------------------------------
Clienta: Alice
Número factura: F00$y-$RANDOM-$RANDOM
Número de compte: EB-2547-02
Any de servei: 20$y" > "$rooms/rebedor/tauleta/calaix_0/contracte_assegurancza_$y.txt"

echo "\
Contracte de l'aigua
----------------------------------------------------------------
Clienta: Alice
Número factura: F00$y-$RANDOM-$RANDOM
Número de compte: EB-2547-02
Any de servei: 20$y" > "$rooms/rebedor/tauleta/calaix_0/contracte_aigua_$y.txt"

echo "\
Contracte de l'electricitat
----------------------------------------------------------------
Clienta: Alice
Número factura: F00$y-$RANDOM-$RANDOM
Número de compte: EB-2547-02
Any de servei: 20$y" > "$rooms/rebedor/tauleta/calaix_0/contracte_electricitat_$y.txt"

done



cat <<'EOF' > "$rooms/rebedor/tauleta/revista_home_style.txt"
HOME STYLE – Juny 2025

REPORTATGE EXCLUSIU:
Com donar vida al teu pis amb plantes d’interior

Articles destacats:
- Decoració low-cost amb palets i llums LED
- Colors de paret que relaxen la ment
- 5 trucs per organitzar els calaixos sense estrès
- Inspira’t: tours per pisos petits però plens d’encant

La revista que et transforma el menjador!
EOF

# Calaix 1
mkdir "$rooms/rebedor/tauleta/calaix_1"


cat <<'EOF' > "$rooms/rebedor/tauleta/calaix_1/contracte_lloguer.txt"
Contracte de lloguer
================================================================
Propietari/a:         Un *vuitre* de merda
Llogatera:            Alice
Adreça de l'immoble:  C/ Major 123, 3r 2a, Barcelona
Data d'inici:         01/01/2016
----------------------------------------------------------------
Renda mensual:        1.81 ronyós
Forma de pagament:    Transferència bancària abans del dia 5
Fiança:               Traspàs de propietat de la teva ànima (ritual pendent)
----------------------------------------------------------------
Condicions:
- No es permeten mascotes sense autorització prèvia.
- L'immoble s'ha de retornar en bon estat de conservació.
- Les reparacions menors seran a càrrec de la llogatera.
- L'ús de l'habitatge és exclusivament residencial.
----------------------------------------------------------------
Signatures:

       Vuitre de merda                      Alice

----------------------------------------------------------------
                        Ni un euro més,
                       vaga de lloguers!
EOF

cat <<'EOF' > "$rooms/rebedor/tauleta/calaix_1/asseguranca_llar.txt"
Assegurança de la llar
================================================================
Companyia: Segurs Catalans, S.A.
Número de pòlissa: H-2025-88917
Titular: Alice
Adreça assegurada: C/ Major 123, 3r 2a, Barcelona
Data d'inici: 15/01/2025
Data de venciment: 14/01/2026
----------------------------------------------------------------
Cobertures principals:
- Danys per incendi i explosió
- Robatori i desperfectes derivats
- Responsabilitat civil (fins a 150.000 €)
- Assistència a la llar 24h
----------------------------------------------------------------
Prima anual: 420 €
Forma de pagament: Càrrec domiciliat trimestral
Franquícia: 150 €
----------------------------------------------------------------
Observacions:
Inclou cobertura addicional per danys elèctrics.
EOF

cat <<'EOF' > "$rooms/rebedor/tauleta/calaix_1/revista_science_today.txt"
SCIENCE TODAY – Abril 2025

GRAN REPORTATGE:
La intel·ligència artificial entra a les nostres llars

Altres temes:
- Robots que aspiren, cuinen i... et fan companyia?
- Energies renovables: plaques solars de balcó
- NASA: entrevista amb una enginyera catalana
- Experiments per fer a casa amb material reciclat

Subscriu-te i descobreix la ciència del futur!
EOF

cat <<'EOF' > "$rooms/rebedor/tauleta/calaix_1/revista_gaming_world.txt"
GAMING WORLD – Juliol 2025

TEMA DE PORTADA:
Els jocs retro tornen amb força

Dins d’aquest número:
- Les consoles clàssiques que marquen tendència
- Guia definitiva de "Legend of Zelda (8-bit)"
- Top 10 arcades per jugar amb col·legues
- Avanç exclusiu: "Galaxy Quest XIII"

REVIVEIX EL GAMING DE LA TEVA INFÀNCIA
EOF

cat <<'EOF' > "$rooms/rebedor/tauleta/calaix_1/revista_cooking_fun.txt"
COOKING FUN – Setembre 2025

PORTADA:
Receptes fàcils que et salvaran el sopar

Continguts:
- Truita vegana en 15 minuts
- Dolços sense forn per impressionar amics
- Menús setmanals per gastar menys
- Entrevista amb una xef de TikTok

CUINAR ÉS JUGAR, I TU EN POTS SER LA PROTA!
EOF

##############
## Passadís ##
##############

mkdir "$rooms/passadis"
echo "🌌" > "$rooms/passadis/quadre_via_lactea.txt"
echo "🔳" > "$rooms/passadis/quadre_quadre_negre_sobre_fons_blanc.txt"
echo "💡" > "$rooms/passadis/llum_lampara_de_peu.txt"

# Quadre de gossos
mkdir "$rooms/passadis/quadre_gossos_jugant_escacs"
echo "♟" > "$rooms/passadis/quadre_gossos_jugant_escacs/quadre_gossos_jugant_escacs.txt"
mkdir "$rooms/passadis/quadre_gossos_jugant_escacs/quadre_electric"

# Test
mkdir       "$rooms/passadis/test"
echo "🪴" > "$rooms/passadis/test/planta_palmera.txt"

# Test > Terra remoguda
mkdir       "$rooms/passadis/test/.terra_remoguda"
echo "🪙" > "$rooms/passadis/test/.terra_remoguda/moneda_perduda.txt"


###########
## Cuina ##
###########

mkdir "$rooms/cuina"

echo "echo -n \"🕰 \";date -u +%I:%M:%S" > "$rooms/cuina/rellotge_de_paret.sh"
chmod +x "$rooms/cuina/rellotge_de_paret.sh"

# Nevera
mkdir       "$rooms/cuina/nevera"
echo "🥬" > "$rooms/cuina/nevera/enciam.txt"
echo "🥕" > "$rooms/cuina/nevera/pastanaga.txt"
echo "🍎" > "$rooms/cuina/nevera/poma.txt"
echo "🍌" > "$rooms/cuina/nevera/platan.txt"
echo "🍇" > "$rooms/cuina/nevera/raim.txt"
echo "🍓" > "$rooms/cuina/nevera/maduixes.txt"
echo "🍍" > "$rooms/cuina/nevera/pinya.txt"
echo "🥒" > "$rooms/cuina/nevera/cogombre.txt"
echo "🌶️" > "$rooms/cuina/nevera/pebrot.txt"

# Banc de cuina
mkdir       "$rooms/cuina/banc_de_cuina"

## Pica
mkdir       "$rooms/cuina/banc_de_cuina/pica"




cat <<"EOF" > "a.sh"
#!/bin/bash

mostrar_ajuda() {
echo "\
Ús: aixeta [OPCIONS] ELEMENT...

Neteja noms d'elements eliminant qualsevol ocurrència de "_brut" o "_bruta" (ignorant l'extensió).

Per cada fitxer o directori proporcionat, si el nom (sense extensió) conté "_brut" o "_bruta",
es renombra eliminant aquestes parts. L'extensió es conserva.

Opcions:
  -h, --help     Mostra aquesta ajuda i surt

Exemples:
  aixeta tassa_bruta           → tassa
  aixeta plat_brut_trencat.txt → plat_trencat.txt
  aixeta sabata_bruteta.txt    → sabataeta.txt (compte amb noms no esperats!)
  aixeta *.txt                 → processa tots els .txt del directori actual
"
}

# Mostrar ajuda si es demana
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  mostrar_ajuda
  exit 0
fi

# Processar cada argument
for item in "$@"; do
  nom=$(basename "$item")
  dir=$(dirname "$item")

  base="${nom%.*}"
  ext=".${nom##*.}"
  [[ "$base" == "$nom" ]] && ext=""

  # Eliminar totes les ocurrències de "_brut" i "_bruta" del nom base
  nou_base="${base//_brut/}"
  nou_base="${nou_base//_bruta/}"

  nou_nom="${nou_base}${ext}"

  if [[ "$nom" != "$nou_nom" ]]; then
    mv "$item" "$dir/$nou_nom"
    echo "✔️ $nom → $nou_nom"
  else
    echo "ℹ️ $nom no s’ha modificat"
  fi
done
EOF




echo "🥣" > "$rooms/cuina/banc_de_cuina/pica/bol_brut_0.txt"
echo "🥣" > "$rooms/cuina/banc_de_cuina/pica/bol_brut_1.txt"
echo "🥄" > "$rooms/cuina/banc_de_cuina/pica/cullera_bruta_0.txt"
echo "🥄" > "$rooms/cuina/banc_de_cuina/pica/cullera_bruta_1.txt"
echo "🥄" > "$rooms/cuina/banc_de_cuina/pica/cullera_bruta_2.txt"
echo "🥄" > "$rooms/cuina/banc_de_cuina/pica/cullera_bruta_3.txt"
echo "🥄" > "$rooms/cuina/banc_de_cuina/pica/cullera_bruta_4.txt"
echo "🥄" > "$rooms/cuina/banc_de_cuina/pica/cullera_bruta_5.txt"
echo "🥄" > "$rooms/cuina/banc_de_cuina/pica/cullera_bruta_6.txt"
echo "🍴" > "$rooms/cuina/banc_de_cuina/pica/forquilla_bruta_0.txt"
echo "🍴" > "$rooms/cuina/banc_de_cuina/pica/forquilla_bruta_1.txt"
echo "🍴" > "$rooms/cuina/banc_de_cuina/pica/forquilla_bruta_2.txt"
echo "🍴" > "$rooms/cuina/banc_de_cuina/pica/forquilla_bruta_3.txt"
echo "🍴" > "$rooms/cuina/banc_de_cuina/pica/forquilla_bruta_4.txt"
echo "🍴" > "$rooms/cuina/banc_de_cuina/pica/ganivet_brut_0.txt"
echo "🍴" > "$rooms/cuina/banc_de_cuina/pica/ganivet_brut_1.txt"
echo "🍴" > "$rooms/cuina/banc_de_cuina/pica/ganivet_brut_2.txt"
echo "🍽" > "$rooms/cuina/banc_de_cuina/pica/plat_brut_0.txt"
echo "🍽" > "$rooms/cuina/banc_de_cuina/pica/plat_brut_1.txt"
echo "🍽" > "$rooms/cuina/banc_de_cuina/pica/plat_brut_2.txt"
echo "🍽" > "$rooms/cuina/banc_de_cuina/pica/plat_brut_3.txt"

## Escorredora
mkdir       "$rooms/cuina/banc_de_cuina/escorredora"
echo "🥣" > "$rooms/cuina/banc_de_cuina/escorredora/bol_0.txt"
echo "🥄" > "$rooms/cuina/banc_de_cuina/escorredora/cullera_0.txt"
echo "🥄" > "$rooms/cuina/banc_de_cuina/escorredora/cullera_3.txt"
echo "🥄" > "$rooms/cuina/banc_de_cuina/escorredora/cullera_4.txt"
echo "🥄" > "$rooms/cuina/banc_de_cuina/escorredora/cullera_5.txt"
echo "🍴" > "$rooms/cuina/banc_de_cuina/escorredora/forquilla_0.txt"
echo "🍽" > "$rooms/cuina/banc_de_cuina/escorredora/plat_0.txt"
echo "🍽" > "$rooms/cuina/banc_de_cuina/escorredora/plat_1.txt"
echo "🍽" > "$rooms/cuina/banc_de_cuina/escorredora/plat_2.txt"

## Cafetera
mkdir "$rooms/cuina/banc_de_cuina/cafetera"
mkdir "$rooms/cuina/banc_de_cuina/cafetera/safata"
mkdir "$rooms/cuina/banc_de_cuina/cafetera/capsules"
for i in $(seq 32)
do
    echo "🟤"  > "$rooms/cuina/banc_de_cuina/cafetera/capsules/capsula_$i"
done

cat <<'EOF' > "$rooms/cuina/banc_de_cuina/cafetera/boto.sh"
#!/bin/bash

last_capsule=$(ls capsules/capsula_*.txt 2>/dev/null | tail -n 1)

# Si no hi ha càpsula, error
if [[ -z "$last_capsule" ]]; then
  sleep 1; echo -n "Beep"
  sleep 1; echo -n ", beep"
  sleep 1; echo -n ", beep!"
  sleep 1; echo
  exit 1
fi

rm $last_capsule
sleep 0.2; echo -n "P"
for i in $(seq 24)
do
  sleep 0.1; echo -n "r"
done
sleep 1; echo -ne "\nGlup"
sleep 0.5; echo -n ", glup"
sleep 0.5; echo ", glup"
sleep 0.5


# Carpeta de la safata
safata="./safata"

# Si hi ha una tassa, la convertim en tassa_de_cafe.txt
if [[ -f "$safata/tassa.txt" ]]; then
  rm "$safata/tassa.txt"
  echo "☕️" > "$safata/tassa_de_cafe.txt"
else
  sleep 0.5; echo "CHOF!"
  # No hi ha tassa: busquem si hi ha cafe_derramat.txt
  if [[ ! -f "$safata/cafe_derramat.txt" ]]; then
    echo "🟤" > "$safata/cafe_derramat.txt"
  elif [[ ! -f "../cafe_derramat.txt" ]]; then
    echo "🟤" > "../cafe_derramat.txt"
  else
    # Buscar el següent número disponible
    i=0
    while [[ -f "../cafe_derramat_$i.txt" ]]; do
      ((i++))
    done
    echo "🟤" > "../cafe_derramat_${i}.txt"
  fi
fi
EOF

# Microones
mkdir "$rooms/cuina/banc_de_cuina/microones/"
cat <<'EOF' > "$rooms/cuina/banc_de_cuina/microones/boto.sh"
#!/bin/bash

path="./interior"

for item in "$path"/*; do
  nom=$(basename "$item")

  base="${nom%.*}"
  ext=".${nom##*.}"
  [[ "$base" == "$nom" ]] && ext=""

  if [[ "$base" == *_calent ]]; then
    file="${base/_calent/_molt_calent}${ext}"
  else
    file="${base}_calent${ext}"
  fi
  mv "$item" "$path/$file"
done
EOF
chmod +x "$rooms/cuina/banc_de_cuina/microones/boto.sh"


############
## Portes ##
############

ln -s "./$rooms_dir/rebedor/"   "$root/casa"

# Rebedor
ln -s "../.."                   "$rooms/rebedor/sortida"
ln -s "../passadis/"            "$rooms/rebedor/passadis"

# Passadís
ln -s "../rebedor/"             "$rooms/passadis/rebedor"
ln -s "../cuina/"               "$rooms/passadis/cuina"

# Cuina
ln -s "../passadis/"            "$rooms/cuina/passadis"
