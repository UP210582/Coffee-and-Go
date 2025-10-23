import React, { useState, useEffect } from "react";

const images = [
  "../../images/randomImagen.png",
];

export default function     Carousel() {
  const [currentIndex, setCurrentIndex] = useState(0);


  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentIndex((prev) => (prev + 1) % images.length);
    }, 4000);
    return () => clearInterval(interval);
  }, []);

  return (
      <div className="relative" style={{ width: "750px", height: "50px", overflow: "hidden", borderRadius: "16px" }}>
      <img
        src={images[currentIndex]}
        alt={`banner-${currentIndex}`}
        style={{
          width: "100%",
          height: "100%",
          objectFit: "cover",
          transition: "all 0.7s",
          display: "block",
        }}
      />
      {/* Indicadores */}
      <div className="absolute bottom-3 w-full flex justify-center gap-2">
        {images.map((_, idx) => (
          <span
            key={idx}
            className={`h-2 w-2 rounded-full ${
              idx === currentIndex ? "bg-red-600" : "bg-gray-300"
            }`}
          ></span>
        ))}
      </div>
    </div>
  );
}
