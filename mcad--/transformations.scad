module scale(v, reference=[0, 0, 0]) {
    translate(-reference) scale(v) translate(reference) child(0);
}
